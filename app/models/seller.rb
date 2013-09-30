class Seller < ActiveRecord::Base
  has_many :items, dependent: :restrict_with_exception

  validates :initials, presence: true, uniqueness: true, length: { in: 2..5 }
  validates :number, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :name, presence: true, uniqueness: true
  validates :rate, presence: true, numericality: true, inclusion: { in: [0.1, 0.15, 0.2], message: "has to be 10, 15 or 20%" }

  def rate_in_percent
    self.rate && (self.rate * 100).round
  end

  def rate_in_percent=(percentage)
    self.rate = percentage && percentage.to_i / 100.0
  end

  def initials=(string)
    super( string.strip.upcase )
  end

  def code
    "#{self.initials}#{"%02d" % self.number}"
  end

  def self.find_by_code(code)
    if pair = split_code(code)
      initials, number = pair
      self.where(initials: initials, number: number).first
    end
  end

  def self.find_all_by_similar_code(code)
    result = []
    if pair = split_code(code)
      initials, number = pair
      result += self.where(initials: initials).all
      result += self.where(number: number).all
    end
    result.uniq!
    result
  end

  def number_of_items
    items.count
  end

  def total_revenue
    items.map {|item| item.price || 0}.inject(0, :+)
  end

  def total_commission
    total_revenue * rate
  end

  def total_payout
    total_revenue - total_commission
  end

  private

  def self.split_code(code)
    if code.strip.upcase =~ /^(?<initials>[[:alpha:]]*)\s*(?<number>\d*)$/
      [ $~[:initials], $~[:number] ]
    end
  end
end


class DummySeller
  attr_accessor :initials, :name, :number, :rate
end
