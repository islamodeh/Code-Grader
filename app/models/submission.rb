class Submission < ApplicationRecord
  belongs_to :student
  belongs_to :work
end
