class Sample < ApplicationRecord
  belongs_to :work
  validates :input, :output, presence: :true
  validates :work_id, uniqueness: { scope: [:input, :output], message: "Sample already exist!" }

  # before save, remove extra spaces and lines both from right and left of each sample!
  # for more accurcy
  before_save :remove_unwanted_characters

  scope :sorted, -> { order(created_at: :asc) }

  def remove_unwanted_characters
    self.input = input.gsub("\r", "")
    self.output = output.gsub("\r", "")
  end
end
