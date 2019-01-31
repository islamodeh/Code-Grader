class Work < ApplicationRecord
  has_many :samples, dependent: :destroy
  has_many :submissions, dependent: :destroy
  belongs_to :course

  validates :description, :work_type, presence: :true
  validates :work_type, inclusion: { in: %w(quiz assignment),
    message: "%{value} is not a valid work type" }
    
  scope :assignments, lambda { where(work_type: "assignment") }
  scope :quizzes, lambda { where(work_type: "quiz") }
end
