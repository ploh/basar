class Transaction < ActiveRecord::Base
  has_many :items, dependent: :destroy

  accepts_nested_attributes_for :items

  def total_price
    items.map {|item| item.price || 0}.inject(0, :+)
  end
end
