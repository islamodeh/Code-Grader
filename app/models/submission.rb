class Submission < ApplicationRecord

  LANGUAGES = %w(C C++)
  C_EX = "#include <stdio.h>
  int main(void) {
    // your code goes here
    return 0;
  }"
  belongs_to :student
  belongs_to :work
  
  validates :code, :language, :status, presence: :true
  
  def run_command(command)
    query = "docker exec -it submission_#{self.id} /bin/sh -c 'cd ~; #{command}'"
    puts query
    `docker exec -it submission_#{self.id} /bin/sh -c 'cd ~; #{command}'`
  end

  def run_code
    # disable internet, put a time limit
    samples = self.work.samples # might be 0 samples
    `docker rm -f submission_#{self.id}`
    `docker run -itd --name "submission_#{self.id}" --user code-grader vm`
    # create source file
    `docker exec -it -e code=#{self.code} submission_#{self.id} /bin/sh -c 'printf "$code" > source_code;`
    # run_command("printf '#{self.code}' > source_file")
  end
end
