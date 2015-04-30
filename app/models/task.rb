class Task < ActiveRecord::Base
  has_many :activities, dependent: :restrict_with_exception
  has_many :sellers, through: :activities
end
