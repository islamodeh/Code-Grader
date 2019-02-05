class Enrollment < ApplicationRecord
  STATUS = %w(Accepted Pending)
  belongs_to :student
  belongs_to :course
  validates :status, inclusion: { in: STATUS,
    message: "%{value} is not a valid status" }
  scope :pending, lambda { where(status: "Pending")}
  scope :accepted, lambda { where(status: "Accepted")}
end
