class Work < ApplicationRecord
  WORK_TYPE = %w(Quiz Assignment)
  attr_accessor :zone_name, :student_id

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
    errors.add(:end_date, "should be greater than start date") if self.start_date >= self.end_date
  end

  def convert_date
    offset = self.start_date.in_time_zone(self.zone_name).zone
    self.start_date = self.start_date - Time.zone_offset(offset).seconds
    self.end_date = self.end_date - Time.zone_offset(offset).seconds
  end
  
  def can_submit?
    self.start_date < self.end_date
  end

  def student_mark
    submission = submissions.where(student_id: student_id).first
    submission.present? ? (submission.status == "Finished".to_sym ? submission.grade : submission.status) : "No submission".to_sym
  end
  
  scope :assignments, lambda { where(work_type: "Assignment".to_sym) }
  scope :quizzes, lambda { where(work_type: "Quiz".to_sym) }
end
