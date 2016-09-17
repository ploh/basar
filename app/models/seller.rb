class Seller < ActiveRecord::Base
  TOTAL_LIMIT = 100
  MODEL_LIMITS = {'A' => [nil, 20],
                  'C' => [nil, nil],
                  'D' => [25, 25],
                  'E' => [10, nil]}

  attr_accessor :warnings

  enum model: [:A, :C, :D, :E]
  def self.models_by_id
    @@models_by_id ||= models.invert
  end

  has_many :items, dependent: :restrict_with_exception

  has_many :activities, dependent: :destroy, inverse_of: :seller
  has_many :tasks, through: :activities, inverse_of: :sellers
  accepts_nested_attributes_for :activities

  belongs_to :user, touch: true

  validates :initials, presence: true, length: { in: 2..3 }, format: { with: /\A[[:alpha:]]*\z/, message: "erlaubt nur Buchstaben" }
  validates :number, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :model, presence: true
  validates :user, presence: true, uniqueness: true

  validate :only_one_delivery
  validate :check_only_d_helps
  validate :check_activity_limits

  validate :check_mandatory_activities
  validate :enough_help_planned

  after_initialize :fill_activities

  before_save :delete_null_activities

  def write_attribute *args
    @activity_counts = nil
    @activities_counts = nil
    @total_revenue = nil
    super *args
  end

  def fill_activities
    each_task_with_activity do |task, activity|
      unless activity
        activity = activities.build(task: task)
        if mandatory? task
          activity.planned_count = 1
        end
      end
    end
  end

  def delete_null_activities
    activities.each do |activity|
      if activity.planned_count == 0 && activity.actual_count == 0
        activities.delete activity
      end
    end
  end

  def each_task_with_activity
    return enum_for(__method__) unless block_given?
    tasks = RequestStore.fetch(:tasks) { Task.list }
    tasks.each do |task|
      activity = activities.find {|act| act.task_id == task.id}
      yield task, activity
    end
  end

  def sorted_activities
    each_task_with_activity.map {|task, activity| activity}.reject(&:nil?)
  end

  def mandatory? task
    (task.must_d && model == 'D') || (task.must_e && model == 'E')
  end

  def only_one_delivery
    if activities.find_all {|act| act.me && act.task.deliver?}.size > 1
      errors[:base] << "Es darf nur ein Abgabetermin ausgewählt werden"
    end
  end

  def name
    user.name
  end

  def check_only_d_helps # actually it is: no A deliver
    if model == 'A' && activities.any? {|act| act.me && act.task.deliver? && act.task.only_d}
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

  def check_mandatory_activities
    each_task_with_activity do |task, activity|
      if mandatory?(task) && activity.planned_count < 0.99
        errors[:base] << "#{task} ist verpflichtend bei Modell #{model}"
      end
    end
  end

  def enough_help_planned
    planned_help = activities.find_all {|act| act.task.bring? || act.task.help?}.map {|act| act.planned_count}.inject(0, :+)
    needed_help =
      case model
      when "A"
        0
      when "C"
        2
      when "D"
        0
      when "E"
        0
      end
    if planned_help < needed_help
      warnings << "Achtung: Noch nicht genug Hilfstermine ausgewählt"
    end
  end

  def color
    if number
      case number % 4
      when 0
        :blue
      when 1
        :red
      when 2
        :green
      when 3
        :black
      end
    end
  end

  def rate
    case model
    when 'A'
      0.2
    when 'C'
      0.1
    when 'D'
      0.1
    when 'E'
      0.0
    end
  end

  def rate_in_percent
    rate && (rate * 100).round
  end

  def initials= string
    super( string && string.strip.upcase )
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
      0.1
    else
      actual_work = activities_counts[0]
      if actual_work > 1.99
        0.1
      else
        0.2
      end
    end
  end

  def final_rate
    # @@@ check model d erfüllt
    unless (rate == 0.1 && computed_rate > 0.1) ||
           (rate < 0.2 && computed_rate == 0.2)
      computed_rate
    else
      0.40
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

  def self.generate_number
    [ User.all.order('old_number desc').limit(1).first.try(:old_number) || 0,
      Seller.all.order('number desc').limit(1).first.try(:number) || 0 ].
    max + 1
  end

  def self.available? model = nil
    if model
      counts = Seller.group(:model).count.map {|model_id, count| [models_by_id[model_id], count]}.to_h
      counts.default = 0

      total_count = counts.values.inject(0, :+)
      if total_count < TOTAL_LIMIT
        model_max = MODEL_LIMITS[model][1]

        model_count = counts[model]
        if !model_max || model_count < model_max
          MODEL_LIMITS.reject {|other, limits| other == model}.none? do |reserved_model, reserved_limits|
            reserved_min = reserved_limits[0]
            if reserved_min
              total_available = TOTAL_LIMIT - total_count
              still_reserved = reserved_min - counts[reserved_model]
              total_available <= still_reserved
            end
          end
        end
      end
    else
      Seller.all.size < TOTAL_LIMIT
    end
  end
end
