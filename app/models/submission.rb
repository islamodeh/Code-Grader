class Submission < ApplicationRecord
  STATUSES = ["Pending",
              "Compilation Failed",
              "Running",
              "Finished",
              "Timed out",
              "Memory limit exceeded"
              ]
  LANGUAGES = %w(C C++)
  C_EX = "#include <stdio.h>
  int main(void) {
    // your code goes here
    return 0;
  }"
  belongs_to :userable, polymorphic: true
  belongs_to :work
  
  validates :code, :language, :status, presence: :true
  validates :status, inclusion: { in: STATUSES }
  validate lambda { errors.add(:submission, "is closed!") if !self.work.can_submit? }
  
  def get_grade(solved)
    samples = self.work.samples
    samples.count == 0 ? 0 : (( (solved.to_f / samples.count) * 100).ceil)
  end
end
