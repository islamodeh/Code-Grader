class CheatLog < ApplicationRecord
  validates :submission_id, :cheated_from_submission_id, :cheat_percentage, presence: true

  belongs_to :submission
end
