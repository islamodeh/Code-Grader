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
    Course.where(id: enrollments.accepted.map(&:course_id))
  end

  def pending_courses
    Course.where(id: enrollments.pending.map(&:course_id))
  end
end
