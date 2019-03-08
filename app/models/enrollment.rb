class Enrollment < ApplicationRecord
  STATUS = %w[Accepted Pending].freeze
  belongs_to :student
  belongs_to :course
  validates :status, inclusion: { in: STATUS,
                                  message: "%{value} is not a valid status" }
  scope :pending, -> { where(status: "Pending") }
  scope :accepted, -> { where(status: "Accepted") }

  after_destroy :remove_submissions!

  # Remove user submissions to all works in the current works.
  def remove_submissions!
    Submission.where(userable: student, work_id: course.works.map(&:id)).destroy_all
  end
end
