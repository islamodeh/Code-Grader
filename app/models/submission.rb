class Submission < ApplicationRecord
  STATUSES = ["Pending",
              "Compilation Failed",
              "Running",
              "Finished",
              "Timed out"
              ]
  LANGUAGES = %w(C C++)
  C_EX = "#include <stdio.h>
  int main(void) {
    // your code goes here
    return 0;
  }"
  belongs_to :student
  belongs_to :work
  
  validates :code, :language, :status, presence: :true
  validates :status, inclusion: { in: STATUSES }
  validate lambda { errors.add(:submission, "is closed!") if !self.work.can_submit? }

  def run_code
    prepare_machine()
    case self.language
    when "C", "C++"
      run_c()
    end
    remove_machine()
  end
  
  private
  
  def run_c
    # rename file extension to cpp
    run_command_in_container_as_root("mv source_code source_code.cpp")
    errors = run_command_in_container_as_user("g++ source_code.cpp -o a.out")
    if errors.present?
      self.update(status: "Compilation Failed".to_sym, grade: 0)
      return
    else
      self.update(status: "Running".to_sym)
    end
    # run samples, handle run time error. use a timer.
    solved = 0
    samples = self.work.samples
    samples.each do |sample|
      output = run_command_in_container_as_user("cat .samples/#{sample.id} | ./a.out")
      if output == sample.output
        solved += 1
      end
    end
    grade = samples.count == 0 ? 0 : (( (solved.to_f / samples.count) * 100).ceil)
    self.update(grade: grade, status: "Finished")
  end
  
  def prepare_machine
    run_docker_command("rm -f submission_#{self.id}")
    ##### disable internet, put a time limit, limit RAM #####
    ##### make sure there is available memory left. status: pending #####
    run_docker_command("run -itd --name submission_#{self.id} vm")
    # copy source code
    file = Tempfile.new("submission_#{self.id}_")
    file.write(self.code)
    file.close()
    begin
      run_docker_command("cp #{file.path} submission_#{self.id}:/home/code-grader/source_code")
    ensure
      file.unlink()
    end
    # copy the samples
    run_command_in_container_as_user("mkdir .samples")
    self.work.samples.each do |sample|
      file = Tempfile.new("sample_#{sample.id}_")
      file.write(sample.input)
      file.close()
      begin
        run_docker_command("cp #{file.path} submission_#{self.id}:/home/code-grader/.samples/#{sample.id}")
      ensure
        file.unlink()
      end
    end
    run_command_in_container_as_root("chown -R code-grader:code-grader . ; chmod -R 700 .")
  end
  
  def remove_machine()
    run_docker_command("rm -f submission_#{self.id}")
  end

  def run_docker_command(command)
    output = `docker #{command} 2>&1`
    if output.include? "Cannot connect to the Docker"
      raise output
    end
  end
  
  def run_command_in_container_as_root(command)
    query = "docker exec -it submission_#{self.id} /bin/sh -c 'cd /home/code-grader; #{command}' 2>&1"
    output = `#{query}`
    if output.include?("Cannot connect to the Docker") || output.include?("Error response from daemon")
      raise output
    else
      puts "--------------------------"
      puts query, output
      puts "--------------------------"
    end
    output
  end
  def run_command_in_container_as_user(command)
    run_command_in_container_as_root("su code-grader -c \"#{command}\" ")
  end
end
