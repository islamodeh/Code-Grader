class Course < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :works, dependent: :destroy
  belongs_to :instructor

  validates :name, :section, :description, presence: :true
  validates :name, uniqueness: { scope: :section,
                                 message: "/ Section Error: a course with the same section number already exist!" }

  def quizzes
    works.quizzes
  end

  def assignments
    works.assignments
  end

  def pending_students
    enrollments.pending
  end

  def enrolled_students
    enrollments.accepted
  end

  def student_grade(student_id)
    return 0 if works.blank?
    sum = 0
    works.each do |work|
      sum += work.student_grade(student_id)
    end
    (sum.to_f / works.count).ceil
  end
end
