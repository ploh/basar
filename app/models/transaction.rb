class Transaction < ActiveRecord::Base
  has_many :items, dependent: :destroy
end
