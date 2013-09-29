class Item < ActiveRecord::Base
  belongs_to :seller
  belongs_to :transaction

  validates :seller, presence: true
#   validates :transaction, presence: true
  validates :price, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 1000 }

  def seller_code
    self.seller && self.seller.code
  end

  def seller_code=(obj)
    sellers = Seller.get_all_by_code( obj )
    if sellers.size == 1
      self.seller = sellers.first
    elsif sellers.empty?
      errors.add :seller, "does not exist"
    else
      errors.add :seller, "Ambiguous seller specification"
    end
    self.seller_code
  end
end
