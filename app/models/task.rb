class Task < ActiveRecord::Base
  has_many :activities
  has_many :sellers, through: :activities
end
