class Seller < ActiveRecord::Base
  has_many :items, dependent: :restrict_with_exception

  has_many :activities, dependent: :destroy
  has_many :tasks, through: :activities
  accepts_nested_attributes_for :activities

  validates :initials, presence: true, length: { in: 2..5 }
  validates :number, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
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
      conditions = {number: number}
      conditions.merge!({initials: initials}) unless initials.blank?
      self.where(conditions).first
    end
  end

  def self.find_all_by_similar_code(code)
    result = []
    if pair = split_code(code)
      initials, number = pair
      result += self.where(initials: initials).to_a unless initials.blank?
      result += self.where(number: number).to_a unless number.blank?
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

  def total_commission(rate = self.rate)
    total_revenue * rate
  end

  def total_payout(rate = self.rate)
    total_revenue - total_commission(rate)
  end

  def to_s
    "<Seller: #{code} #{name}, #{rate_in_percent}%>"
  end

  def activity_summary(task)
    counts = activity_counts(task)
    "#{counts[0]} / #{counts[1]}"
  end

  def self.activities_summary(task)
    counts = [0, 0]
    Seller.all.each do |seller|
      seller_counts = seller.activity_counts(task)
      counts[0] += seller_counts[0]
      counts[1] += seller_counts[1]
    end
    "#{counts[0]} / #{counts[1]}"
  end

  def activity_counts(task)
    activity = activities.find_by(task: task)
    if activity
      [activity.actual_count, activity.planned_count]
    else
      [0, 0]
    end
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
