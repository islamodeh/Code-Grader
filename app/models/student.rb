class Student < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
         # :confirmable
  
  has_many :enrollments, dependent: :destroy
  # has_many :courses, through: :enrollments
  has_many :submissions, dependent: :destroy

  def courses
    enrollments.accepted
  end

  def pending_courses
    enrollments.pending
  end
end
