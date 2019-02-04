class Course < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments
  has_many :works, dependent: :destroy
  belongs_to :instructor
  
  validates :name, :section, presence: :true
  validates :name, uniqueness: { scope: :section, message: "/ Section Error: a course with the same section number already exist!" }
  
  def quizzes
    works.quizzes
  end
  
  def assignments
    works.assignments
  end
end
