class Sample < ApplicationRecord
  belongs_to :work
  validates :input, :output, presence: :true
  validates :work_id, uniqueness: { scope: [:input, :output], message: "Sample already exist!" }

  before_save :remove_unwanted_characters
  before_save :strip_samples

  scope :sorted, -> { order(created_at: :asc) }

  def remove_unwanted_characters
    self.input = input.gsub("\r\n", "\n")
    self.output = output.gsub("\r\n", "\n")
  end

  def strip_samples
    self.input = input.strip
    self.output = output.strip
  end
end
