class Student < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments
  has_many :submissions, dependent: :destroy
  has_secure_password
end
