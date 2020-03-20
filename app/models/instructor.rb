class Instructor < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable,
         :confirmable
  # validate :check_instructor
  # validates :full_name, presence: true

  has_many :courses, dependent: :destroy
  has_many :submissions, dependent: :destroy, as: :userable

  def check_instructor
    errors.add(:email, "should include @psut.edu.jo") if !email.include?("@psut.edu.jo")
  end
end
