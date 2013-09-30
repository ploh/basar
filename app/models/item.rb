class Item < ActiveRecord::Base
  belongs_to :seller
  belongs_to :transaction

  validates :price, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 1000 }
  validates :transaction, presence: true
  validate :seller_uniquely_exists

  def seller_uniquely_exists
    unless seller.kind_of? Seller
      msg = "does not exist"
      if seller
        sellers = Seller.get_all_by_code(seller)
        unless sellers.empty?
          msg << ", maybe you meant one of #{sellers.join(", ")}"
        end
      end
      errors.add :seller, msg
    end
  end

  def seller_code
    if seller.kind_of? Seller
      self.seller.code
    else
      self.seller
    end
  end

  def seller_code=(obj)
    sellers = Seller.get_all_by_code( obj )
    if sellers.size == 1
      self.seller = sellers.first
    else
      @seller = obj
    end
    self.seller_code
  end
end
