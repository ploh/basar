class Transaction < ActiveRecord::Base
  has_many :items
end
