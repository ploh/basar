class Transaction < ActiveRecord::Base
  has_many :items, dependent: :destroy

  accepts_nested_attributes_for :items

#   around_save do
#     big_bang = Time.at(0)
#     newest_update = (items.map {|item| item.updated_at || big_bang} + [self.updated_at || big_bang]).max
#     self.updated_at =  newest_update == big_bang ? nil : newest_update
#   end

  def total_price
    items.map {|item| item.price || 0}.inject(0, :+)
  end

  def number_of_items
    items.map {|i| 1}.inject(0, :+)
  end
end
