class Sample < ApplicationRecord
  belongs_to :work
  validates :input, :output, presence: :true
  validates :work_id, uniqueness: { scope: [:input, :output], message: "Sample already exist!" }

  # before save, remove extra spaces and lines both from right and left of each sample!
  # for more accurcy
  scope :sorted, lambda { order(created_at: :asc)}
end
