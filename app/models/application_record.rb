class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  # Show all attributes of devise.
  def serializable_hash(options = nil) 
    super(options).merge(self.attributes) 
  end
end
