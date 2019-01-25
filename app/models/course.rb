class Course < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments
  has_many :works, dependent: :destroy
  belongs_to :instructor
end
