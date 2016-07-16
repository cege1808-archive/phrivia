class Question < ActiveRecord::Base

  # Associations
  belongs_to :player
  has_many :answers

end