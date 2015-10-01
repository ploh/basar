class Transaction < ActiveRecord::Base
  belongs_to :user
  has_many :items, inverse_of: :purchase, dependent: :destroy

  accepts_nested_attributes_for :items

  before_save do
    items.each {|item| item.destroy if item.price == 0.0}
  end


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

  def self.create_dummy
    new
  end

  def user_description
    user && user.email
  end
end
