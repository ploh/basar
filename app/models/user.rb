class User < ActiveRecord::Base
  @@max_sellers = 105
  @@max_model_a = 27
  @@reserved_model_d = 23
  @@max_model_d = @@reserved_model_d

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  enum role: [:seller, :assistant, :admin]
  enum seller_model: [:A, :B, :C, :D]

  has_many :transactions, dependent: :restrict_with_exception

  after_initialize :set_default_role, :if => :new_record?

  before_validation :auto_set_seller_code

  with_options if: :seller? do |seller|
    seller.validates :seller_model, presence: true
    seller.validates :initials, length: { in: 2..3 }, format: { with: /\A[[:alpha:]]+\z/, message: "erlaubt nur Buchstaben" }, allow_blank: true
    seller.validates :seller_number, uniqueness: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, allow_nil: true
  end

  with_options unless: :seller? do |assistant|
    assistant.validates :seller_model, absence: true
    assistant.validates :initials, absence: true
    assistant.validates :seller_number, absence: true
  end

  validates :role, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  validate :seller_and_model_available


  def set_default_role
    self.role ||= :seller
  end

  def name
    "#{first_name} #{last_name}"
  end

  def description
    "#{name} (#{email})"
  end

  def initials= string
    super( string && string.strip.upcase )
  end

  def seller_code
    Seller.seller_code initials, seller_number
  end

  def color
    if seller_number
      case seller_number % 4
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

  def auto_set_seller_code
    if !seller_number && initials.blank? && email
      lookup = Seller.old_list[email.downcase]
      if lookup && !lookup[0].blank? && lookup[1]
        self.initials = lookup[0]
        self.seller_number = lookup[1]
        Rails.logger.info "Auto set for #{email}: #{initials}, #{seller_number}"
        unless valid?
          Rails.logger.warn "Auto set reverted for #{email}: #{initials}, #{seller_number}, #{errors.full_messages.join("; ")}"
          errors.clear
          self.initials = nil
          self.seller_number = nil
        end
      end
    end
    true
  end

  private

  def seller_available
  end

  def seller_and_model_available
    if seller?
      model_counts = User.seller.where.not(id: id).group(:seller_model).count
      model_counts.default = 0
      sellers_count = model_counts.values.inject(:+)
      if new_record? && sellers_count >= @@max_sellers
        errors.clear
        errors[:base] << "Anmeldung nicht mehr möglich"
      else
        if D?
          if model_counts[User.seller_models[:D]] >= @@max_model_d
            errors.add :seller_model, "D nicht mehr verfügbar"
          end
        else
          if sellers_count - model_counts[User.seller_models[:D]] >= @@max_sellers - @@reserved_model_d
            errors.add :seller_model, "#{seller_model} nicht mehr verfügbar (nur noch D verfügbar)"
          elsif A? && model_counts[User.seller_models[:A]] >= @@max_model_a
            errors.add :seller_model, "A nicht mehr verfügbar"
          end
        end
      end
    end
  end
end
