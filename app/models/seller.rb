class Seller < ActiveRecord::Base
  has_many :items, dependent: :restrict_with_exception

  def rate_in_percent
    self.rate && (self.rate * 100).round
  end

  def rate_in_percent=(percentage)
    self.rate = percentage.to_i / 100.0
  end
end
