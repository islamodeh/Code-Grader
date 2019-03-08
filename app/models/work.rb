class Work < ApplicationRecord
  WORK_TYPE = %w[Quiz Assignment].freeze
  attr_accessor :zone_name

  has_many :samples, dependent: :destroy
  has_many :submissions, dependent: :destroy
  belongs_to :course

  validates :description, :work_type, :name,
            :start_date, :end_date, presence: :true
  validates :work_type, inclusion: { in: WORK_TYPE,
                                     message: "%{value} is not a valid work type" }
  validate :check_dates

  before_save :convert_date

  def check_dates
    errors.add(:end_date, "should be greater than start date") if start_date >= end_date
  end

  def convert_date
    self.start_date = start_date - TZInfo::Timezone.get(zone_name).current_period.offset.utc_total_offset
    self.end_date = end_date - TZInfo::Timezone.get(zone_name).current_period.offset.utc_total_offset
  end

  def can_submit?
    DateTime.now >= start_date && DateTime.now < end_date
  end

  def student_grade(student_id)
    grade = submissions.where(userable_id: student_id, userable_type: "Student").maximum(:grade)
    grade.present? ? grade : 0
  end

  scope :assignments, -> { where(work_type: "Assignment".to_sym) }
  scope :quizzes, -> { where(work_type: "Quiz".to_sym) }
end
