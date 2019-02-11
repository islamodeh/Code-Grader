class Submission < ApplicationRecord
  LANGUAGES = %w(C C++)
  C_EX = "#include <stdio.h>
int main(void) {
  // your code goes here
  return 0;
}"
  belongs_to :student
  belongs_to :work
  
  validates :code, :language, presence: :true
end
