class RunCode < ActiveJob::Base
  include SuckerPunch::Job
  attr_accessor :submission

  def perform(submission)
    @submission = submission
    @dir_path = "/"
    @file_path = @dir_path + "source#{@submission.extension}"
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
      @docker_container.store_file(@file_path, @submission.code)

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
    compile_c
    binding.pry
    solved = 0
    samples = @submission.work.samples

    # samples.each do |sample|
    #   output = nil

    #   solved += 1 if output == sample.output
    # end
    # @submission.update(grade: @submission.get_grade(solved), status: "Finished".to_sym)
  end

  def compile_c
    cmd = "#{@submission.compiler} #{@file_path} -o #{@dir_path}a.out"
    run_bash_command(cmd)
  end

  def run_bash_command(cmd)
    result = @docker_container.exec(cmd.split(" "))

    if !result[2].zero?
      puts "Error in bash cmd: ",  result
    end
    result
  end
end
