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
  validate -> lambda { errors.add(:submission, "is closed!") if !self.work.can_submit? }
  
  def escape_code
    
  end

  def run_code
    prepare_machine()
    case self.language
    when "C", "C++"
      run_c()
    end
  end
  
  private
  
  def run_c
    # rename file extension to cpp
    run_command("mv source_code source_code.cpp")
    errors = run_command("g++ source_code.cpp 2>&1")
    if errors.present?
      self.update(status: "Compilation Failed".to_sym, grade: 0)
      return
    else
      self.update(status: "Running".to_sym)
    end
    # run samples, handle run time error. use a timer.
    self.work.samples.each do |sample|

    end
  end
  
  def prepare_machine
    `docker rm -f submission_#{self.id}`
    # disable internet, put a time limit, limit RAM
    # make sure there is available memory left. status: pending
    `docker run -itd --name "submission_#{self.id}" vm`
    # create source file
    file = Tempfile.new("submission_#{self.id}_")
    file.write(self.code)
    file.close()
    begin
      `docker cp #{file.path} submission_#{self.id}:/home/code-grader`
    ensure
      file.unlink()
    end
    run_command("mv submission_* source_code")
    run_command("chown code-grader:code-grader source_code; chmod 600 source_code")
  end
  
  def run_command(command)
    query = "docker exec -it submission_#{self.id} /bin/sh -c 'cd /home/code-grader; #{command}'"
    puts query
    `#{query}`
  end
end
