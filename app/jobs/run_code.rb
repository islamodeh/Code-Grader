class RunCode < ActiveJob::Base
  include SuckerPunch::Job
  attr_accessor :submission

  def perform(submission)
    @submission = submission
    @dir_path = "/"
    @source_code_path = @dir_path + "source#{@submission.extension}"
    @input_path = @dir_path + ".input.txt"
    run_code!
  end

  private

  def run_code!
    # if @submission.userable_type != "Instructor" && @submission.cheating?
    #   @submission.update(grade: 0, status: "Cheated")
    #   return
    # end

    begin
      @docker_container = @submission.create_container!
      @docker_container.start
      @docker_container.store_file(@source_code_path, @submission.code)

      case @submission.language
      when "c", "c++"
        run_c
      else
        raise "Invalid language"
      end
    rescue => e
      puts "Error: #{e}"
      @submission.update_column(:status, "Fatal Error")
    ensure
      if @docker_container.present?
        puts "Removing Container for submission #{@submission.id}"
        @docker_container.delete(force: true) 
      end
    end
  end

  def run_c
    compile_c!
    solved = 0
    samples = @submission.work.samples

    samples.each do |sample|
      @docker_container.store_file(@input_path, sample.input)
      output_result = run_bash_command("#{@dir_path}a.out < #{@input_path}")

      if output_result[2].zero? && output_result[0][0] == sample.output
        solved += 1
      end
    end
    @submission.update(grade: @submission.get_grade(solved), status: "Finished".to_sym)
  end

  def compile_c!
    cmd = "#{@submission.compiler} #{@source_code_path} -o #{@dir_path}a.out"
    result = run_bash_command(cmd)
    raise "Compilation error" if !result[2].zero?
  end

  def run_bash_command(cmd)
    result = @docker_container.exec(["bash", "-c", cmd])

    if !result[2].zero?
      puts "Error in bash cmd: ",  result
    end
    result
  end
end
