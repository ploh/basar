class Task < ActiveRecord::Base
  has_many :activities, dependent: :restrict_with_exception
  has_many :sellers, through: :activities, inverse_of: :tasks

  enum kind: [:bring, :help, :deliver]

  validates :sort_key, presence: true
end
