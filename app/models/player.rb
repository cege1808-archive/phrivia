class Player < ActiveRecord::Base

  # Associations
  has_many :questions
  has_many :answers

end