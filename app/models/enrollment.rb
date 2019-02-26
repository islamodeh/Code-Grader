class Enrollment < ApplicationRecord
  STATUS = %w(Accepted Pending)
  belongs_to :student
  belongs_to :course
  validates :status, inclusion: { in: STATUS,
    message: "%{value} is not a valid status" }
  scope :pending, lambda { where(status: "Pending")}
  scope :accepted, lambda { where(status: "Accepted")}

  after_destroy :remove_submissions!
  
  def remove_submissions!
    Submission.where(userable: self.student, work_id: self.course.works.map(&:id)).destroy_all
  end
end
