class Student < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable,
         :confirmable
  # validate :check_student
  # validates :full_name, presence: true

  has_many :enrollments, dependent: :destroy
  has_many :submissions, as: :userable, dependent: :destroy

  def courses
    Course.where(id: enrollments.accepted.map(&:course_id))
  end

  def pending_courses
    Course.where(id: enrollments.pending.map(&:course_id))
  end

  def check_student
    errors.add(:email, "should include @std.psut.edu.jo") if !email.include?("@std.psut.edu.jo")
  end
end
