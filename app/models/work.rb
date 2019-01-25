class Work < ApplicationRecord
  has_many :samples, dependent: :destroy
  has_many :submissions, dependent: :destroy
  belongs_to :course
end
