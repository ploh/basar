class Seller < ActiveRecord::Base
  attr_accessor :warnings

  enum model: [:A, :B, :C, :D]

  has_many :items, dependent: :restrict_with_exception

  has_many :activities, dependent: :destroy
  has_many :tasks, through: :activities, inverse_of: :sellers
  accepts_nested_attributes_for :activities

  belongs_to :user, touch: true

  validates :initials, presence: true, length: { in: 2..3 }, format: { with: /\A[[:alpha:]]*\z/, message: "erlaubt nur Buchstaben" }
  validates :number, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  validate :only_one_delivery
  validate :check_only_d_helps
  validate :check_activity_limits

  validate :enough_help_planned

  before_validation :fill_activities
  before_validation :correct_must_d_activities

  def write_attribute *args
    @activity_counts = nil
    @activities_counts = nil
    @total_revenue = nil
    super *args
  end

  def fill_activities
    for_each_task_with_activity do |task, activity|
      activities.build(task: task) unless activity
    end
  end

  def correct_must_d_activities
    for_each_task_with_activity do |task, activity|
      if task.must_d
        activity.planned_count = user && user.D? ? 1 : 0
        activity.actual_count = 0 unless user && user.D?
      end
    end
  end

  private

  def for_each_task_with_activity
    tasks = RequestStore.fetch(:tasks) { Task.list }
    tasks.each do |task|
      activity = activities.find {|act| act.task_id == task.id}
      yield task, activity
    end
  end

  public

  def only_one_delivery
    if activities.find_all {|act| act.me && act.task.deliver?}.size > 1
      errors[:base] << "Es darf nur ein Abgabetermin ausgewählt werden"
    end
  end

  def check_only_d_helps # actually it is: no A deliver
    if user.A? && activities.any? {|act| act.me && act.task.deliver? && act.task.only_d}
      errors[:base] << "Dieser Abgabetermin ist für Verkäufer mit Modell A nicht erlaubt"
    end
  end

  def check_activity_limits
    activities.each do |act|
      planned_other = Activity.where.not(seller: self).where(task: act.task).sum(:planned_count)
      if planned_other + act.planned_count > act.task.limit
        kind_text = case act.task.kind
          when "help"
            "Hilfstermin: "
          when "deliver"
            "Abgabetermin: "
          else
            ""
          end
        errors[:base] << kind_text + act.task.description + " nicht mehr verfügbar"
      end
    end
  end

  def warnings
    @warnings ||= []
  end

  def enough_help_planned
    planned_help = activities.find_all {|act| act.task.bring? || act.task.help?}.map {|act| act.planned_count}.inject(0, :+)
    needed_help = case user.seller_model
    when "A"
      0
    when "B"
      1
    when "C"
      2
    when "D"
      0
    end
    if planned_help < needed_help
      warnings << "Achtung: Noch nicht genug Hilfstermine ausgewählt"
    end
  end

  def rate
    case model
    when 'A'
      0.2
    when 'B'
      0.15
    when 'C'
      0.1
    when 'D'
      0.05
    end
  end

  def rate_in_percent
    rate && (rate * 100).round
  end

  def initials=(string)
    super( string.strip.upcase )
  end

  def code
    Seller.seller_code self.initials, self.number
  end

  def self.seller_code initials, number
    "#{initials}#{number && ("%02d" % number)}"
  end

  def self.find_by_code(code)
    sellers = RequestStore.fetch(:sellers) { Seller.list false }
    if pair = split_code(code)
      initials, number = pair
      sellers.find {|seller| seller.number == number.to_i && (initials.blank? || seller.initials == initials)}
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
    items.size
  end

  def total_revenue
    @total_revenue ||= items.map {|item| item.price || 0}.inject(0, :+)
  end

  def total_commission(rate = self.final_rate)
    total_revenue * rate
  end

  def total_payout(rate = self.final_rate)
    total_revenue - total_commission(rate)
  end

  def to_s
    "<Seller: #{code} #{name}, #{rate_in_percent}%>"
  end

  def activity_summary(task)
    counts = activity_counts(task)
    "#{counts[0]} / #{counts[1]}"
  end

  def activities_summary
    counts = activities_counts
    "#{counts[0]} / #{counts[1]}"
  end

  def computed_rate
    if activities.any? {|act| act.task.must_d && act.actual_count > 0.99}
      0.05
    else
      actual_work = activities_counts[0]
      if actual_work > 1.99
        0.1
      elsif actual_work > 0.99
        0.15
      else
        0.2
      end
    end
  end

  def final_rate
    # @@@ check model d erfüllt
    unless (rate == 0.05 && computed_rate > 0.05) ||
           (rate < 0.2 && computed_rate == 0.2)
      computed_rate
    else
      0.30
    end
  end

  def final_rate_in_percent
    self.final_rate && (self.final_rate * 100).round
  end

  def self.list(includes = true, with_items = false)
    if includes
      if with_items
        Seller.includes(:user, :items, activities: :task).order("number").to_a
      else
        Seller.includes(:user, activities: :task).order("number").to_a
      end
    else
      Seller.order("number").to_a
    end
  end

  def computed_rate_in_percent
    self.computed_rate && (self.computed_rate * 100).round
  end

  def self.activities_summary
    counts = [0, 0]
    sellers = RequestStore.fetch(:sellers) { Seller.list }
    sellers.each do |seller|
      seller_counts = seller.activities_counts
      counts[0] += seller_counts[0]
      counts[1] += seller_counts[1]
    end
    "#{counts[0]} / #{counts[1]}"
  end

  def self.activity_summary task
    counts = [0, 0]
    sellers = RequestStore.fetch(:sellers) { Seller.list }
    sellers.each do |seller|
      seller_counts = seller.activity_counts(task)
      counts[0] += seller_counts[0]
      counts[1] += seller_counts[1]
    end
    "#{counts[0]} / #{counts[1]}"
  end

  def activity_counts(task)
    @activity_counts ||= {}
    unless @activity_counts[task]
      activity = activities.select {|act| act.task_id == task.id}.first
      @activity_counts[task] =
        if activity
          [activity.actual_count, activity.planned_count].map do |float|
            int = float.round
            int == float ? int : float.round(2)
          end
        else
          [0, 0]
        end
    end
    @activity_counts[task]
  end

  def activities_counts
    unless @activities_counts
      @activities_counts = [0, 0]
      tasks = RequestStore.fetch(:tasks) { Task.list }
      tasks.each do |task|
        task_counts = activity_counts(task)
        @activities_counts[0] += task_counts[0]
        @activities_counts[1] += task_counts[1]
      end
    end
    @activities_counts
  end

  def self.split_code(code)
    if code.strip.upcase =~ /^(?<initials>[[:alpha:]]*)\s*(?<number>\d*)$/
      [ $~[:initials], $~[:number] ]
    end
  end
end
