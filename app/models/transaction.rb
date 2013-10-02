class Transaction < ActiveRecord::Base
  has_many :items, dependent: :destroy

  accepts_nested_attributes_for :items

  before_save do
    items.each {|item| item.destroy if item.price == 0.0}
  end

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

  def self.create_dummy_transactions(quantity)
    start = Time.now
    seed = Random.new_seed
    p "Random seed: #{seed}"
    generator = Random.new seed
    sellers = Seller.all.to_a
    quantity.times do
      transaction = Transaction.new
      number_of_items = generator.rand(10..20)
      number_of_items.times do
        seller = sellers.sample
        price = (generator.rand * 100).round / 10.0
        transaction.items.build(seller: seller, price: price)
      end
      unless transaction.save
        raise
      end
    end
    p "Created #{quantity} random transactions in #{Time.now-start} seconds"
  end
end
