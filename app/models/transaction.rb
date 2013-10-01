class Transaction < ActiveRecord::Base
  has_many :items, dependent: :destroy

  accepts_nested_attributes_for :items

  before_save do
    self.updated_at = (items.map {|item| item.updated_at || Time.at(0)} + [self.updated_at || Time.at(0)]).max
  end

  def total_price
    items.map {|item| item.price || 0}.inject(0, :+)
  end

  def number_of_items
    items.count
  end
end
