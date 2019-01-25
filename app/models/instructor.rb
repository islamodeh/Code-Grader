class Instructor < ApplicationRecord
  has_many :courses, dependent: :destroy
  has_secure_password
end
