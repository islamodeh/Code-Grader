class Work < ApplicationRecord
  WORK_TYPE = %w(Quiz Assignment)
  attr_accessor :zone_name

  has_many :samples, dependent: :destroy
  has_many :submissions, dependent: :destroy
  # belongs_to :course

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

  scope :assignments, lambda { where(work_type: "Assignment") }
  scope :quizzes, lambda { where(work_type: "Quiz") }
end
