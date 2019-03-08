class RunCode < ActiveJob::Base
  include SuckerPunch::Job
  attr_accessor :submission

  def perform(submission)
    @submission = submission
    run_code
  end

  private

  def run_code
    if @submission.userable_type != "Instructor" && @submission.cheating?
      @submission.update(grade: 0, status: "Cheated")
      return
    end

    begin
      prepare_machine()
      case @submission.language
      when "C", "C++"
        run_c()
      end
    ensure
      remove_machine()
    end
  end
  
  def run_c
    compiler = @submission.language == "C" ? "gcc" : "g++"
    extension = @submission.language == "C" ? "c" : "cpp"

    run_command_in_container_as_user("mv source_code source_code.#{extension}")
    errors = run_command_in_container_as_user("#{compiler} -w source_code.#{extension} -o a.out")
    if errors.present?
      @submission.update(status: "Compilation Failed".to_sym, grade: 0)
      return
    else
      @submission.update(status: "Running".to_sym)
    end
    solved = 0
    samples = @submission.work.samples
    samples.each do |sample|
      output = ''
      begin Timeout::timeout(2){
      output = run_command_in_container_as_user("cat .samples/#{sample.id} | ./a.out")
      if output.downcase.include?("segmentation fault")
        @submission.update(status: "Memory limit exceeded".to_sym, grade: 0)
        return
      end
      }
      rescue Timeout::Error
        @submission.update(status: "Timed out".to_sym, grade: 0)
        return
      end
      solved += 1 if output == sample.output
    end
    @submission.update(grade: @submission.get_grade(solved), status: "Finished".to_sym)
  end
  
  
  ##### VIRTUAL MACHINE FUNCTIONS #####

  def prepare_machine
    ##### make sure there is available memory & cpu left. ##### DO ME!
    run_docker_command("run --cap-add=sys_nice -itd --network none --memory=256m --memory-swap=256m --name submission_#{@submission.id} vm")

    #copy the code
    file = Tempfile.new("submission_#{@submission.id}_")
    file.write(@submission.code)
    file.close()
    begin
      run_docker_command("cp #{file.path} submission_#{@submission.id}:/home/code-grader/source_code")
    ensure
      file.unlink()
    end
    
    # copy the samples
    run_command_in_container_as_root("mkdir .samples")
    @submission.work.samples.each do |sample|
      file = Tempfile.new("sample_#{sample.id}_")
      file.write(sample.input)
      file.close()
      begin
        run_docker_command("cp #{file.path} submission_#{@submission.id}:/home/code-grader/.samples/#{sample.id}")
      ensure
        file.unlink()
      end
    end
    run_command_in_container_as_root("chown -R code-grader:code-grader . ; chmod -R 700 .")
  end
  
  def remove_machine()
    run_docker_command("rm -f submission_#{@submission.id}")
  end

  def run_docker_command(command)
    output = `docker #{command} 2>&1`
    output = output.downcase
    if output.include?("cannot connect to the docker") || output.include?("error") || output.include?("errors")
      raise output
    else
      # LOG ME
      puts '-------------------------------------------'
      puts command, output
      puts '-------------------------------------------'
    end
  end
  
  def run_command_in_container_as_root(command, skip_raise = false)
    query = "docker exec -i submission_#{@submission.id} /bin/sh -c 'cd /home/code-grader; #{command}' 2>&1"
    output = `#{query}`
    output = output.downcase
    if output.include?("cannot connect to the docker") || output.include?("error") || output.include?("errors")
      skip_raise.present? ? (puts "LOG ME as user ERROR -> #{output}") : (raise output)
    elsif output.include? "killed"
      @submission.update(status: "Memory limit exceeded".to_sym, grade: 0)
      raise("Container got killed!")
    else
      # LOG ME
      puts "--------------------------"
      puts query, output
      puts "--------------------------"
    end
    output
  end
  
  def run_command_in_container_as_user(command)
    run_command_in_container_as_root("su code-grader -c \"#{command}\" ", true)
  end
end
