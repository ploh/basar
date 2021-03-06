class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  enum role: [:seller, :assistant, :admin]

  has_many :transactions, dependent: :restrict_with_exception
  has_one :seller, dependent: :destroy

  after_initialize :set_default_role, :if => :new_record?

  with_options unless: :seller? do |assistant|
    assistant.validates :seller, absence: true
  end

  validates :role, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validate :wishes_are_consistent

  validates :old_initials, length: { in: 2..3 }, format: { with: /\A[[:alpha:]]*\z/, message: "erlaubt nur Buchstaben" }, allow_blank: true
  validates :old_number, uniqueness: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, allow_nil: true


  # s. http://stackoverflow.com/a/6004353
  # this method is called by devise to check for "active" state of the model
  def active_for_authentication?
    super &&
      ( assistant? ||
        admin? ||
        Time.zone.now < Time.zone.local(2016, 10, 29, 9, 0, 0) ||
        Time.zone.local(2016, 10, 29, 13, 0, 0) < Time.zone.now )
  end
  # @@@ def inactive_message, s. http://www.rubydoc.info/github/plataformatec/devise/master/Devise/Models/Authenticatable
  # https://github.com/plataformatec/devise/wiki/How-To%3a-Customize-user-account-status-validation-when-logging-in

  def set_default_role
    self.role ||= :seller
  end

  def weighting
    super || 0.0
  end

  def name
    "#{first_name} #{last_name}"
  end

  def description
    "#{name} (#{email})"
  end

  def to_s
    description
  end

  def seller_code
    seller && seller.code
  end

  def old_seller_code
    old_number && Seller.seller_code(old_initials, old_number)
  end

  def seller_color
    seller && seller.color
  end

  def seller_number
    seller && seller.number
  end

  def wishes
    result = [:wish_a, :wish_b, :wish_c].map do |wish|
      wish_val = send wish
      wish_val && Seller.models.find {|k, v| v == wish_val}[0]
    end
    result << 'K' if cake
    result << 'H' if help
    result
  end

  def wishes_text
    wishes.reject(&:nil?).join ', '
  end

  def initials
    first_name[0] + last_name[0]
  end

  def self.list
    User.includes(:seller).sort_by {|user| [-user.role, user.seller_number || 0, user.old_number || 0, user.last_name.downcase]}
  end

  private

  def wishes_are_consistent
    seller_applied = false
    previous_wishes = []
    [:wish_a, :wish_b, :wish_c].each do |wish_sym|
      wish = send wish_sym
      if wish
        seller_applied = true
        if !previous_wishes.empty? && !previous_wishes.last
          errors.add wish_sym, "ungültig, da höherwertiger Wunsch nicht angegeben"
        end

        if previous_wishes.include? wish
          errors.add wish_sym, "ungültig, da bereits bei höherwertigem Wunsch angegeben"
        end

        unless Seller.models.values.include? wish
          errors.add wish_sym, "ungültig"
        end

      end
      previous_wishes << wish
    end

    if seller_applied && (cake || help)
      errors[:base] << "Verkäuferplatz beantragen und Vorkaufsrecht für Essen/Hilfe nicht gleichzeitig möglich"
    end

    if cake && help
      errors[:base] << "Vorkaufsrecht für Essen und Hilfe nicht gleichzeitig möglich"
    end
  end
end
