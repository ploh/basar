class Item < ActiveRecord::Base
  belongs_to :seller
  belongs_to :purchase, class_name: :transaction  #, touch: true

  validates :price, presence: true, numericality: { greater_than: -1000, less_than_or_equal_to: 1000 }
#   validates :transaction, presence: true
  validate :seller_code_uniquely_exists

  def seller_code_uniquely_exists
    unless seller
      msg = "does not exist"
      sellers = Seller.find_all_by_similar_code(seller_code)
      unless sellers.empty?
        msg << ", maybe you meant #{sellers.size > 1 ? "one of " : ""}#{sellers.map {|s| s.code}.join(", ")}"
      end
      errors.add :seller_code, msg
    end
  end

  def seller=(*args, &block)
    @seller_code = nil
    super(*args, &block)
  end

  def seller_code
    if self.seller
      self.seller.code
    else
      @seller_code
    end
  end

  def seller_code=(code)
    seller = Seller.find_by_code(code)
    self.seller = seller
    unless seller
      @seller_code = code
    end
    self.seller_code
  end

  def self.create_dummy
    new seller: Seller.first, price: 0.00
  end
end
