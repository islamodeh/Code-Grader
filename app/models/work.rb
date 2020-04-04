class Work < ApplicationRecord
  WORK_TYPE = %w[Quiz Assignment].freeze
  has_many :samples, dependent: :destroy
  has_many :submissions, dependent: :destroy
  belongs_to :course

  validates :description, :work_type, :name,
            :start_date, :end_date, presence: :true
  validates :work_type, inclusion: { in: WORK_TYPE,
                                     message: "%{value} is not a valid work type" }
  validate :check_dates

  scope :assignments, -> { where(work_type: "Assignment".to_sym) }
  scope :quizzes, -> { where(work_type: "Quiz".to_sym) }

  def check_dates
    errors.add(:end_date, "should be greater than start date") if start_date >= end_date
  end

  def can_submit?
    DateTime.utc.now >= start_date && DateTime.utc.now <= end_date
  end

  def student_grade(student_id)
    grade = submissions.where(userable_id: student_id, userable_type: "Student").maximum(:grade)
    grade.present? ? grade : 0
  end
end
