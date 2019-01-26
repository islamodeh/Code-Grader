class Student < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments
  has_many :submissions, dependent: :destroy
end
