class User < ActiveRecord::Base
  attr_accessor :current_user

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

  has_many :transactions, dependent: :restrict_with_exception
  has_one :seller, dependent: :destroy

  after_initialize :set_default_role, :if => :new_record?

  with_options unless: :seller? do |assistant|
    assistant.validates :seller, absence: true
  end

  validates :role, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  validate :seller_and_model_available


 # s. http://stackoverflow.com/a/6004353
 # this method is called by devise to check for "active" state of the model
  def active_for_authentication?
    super &&
      ( assistant? ||
        admin? ||
        Time.zone.now < Time.zone.local(2016, 4, 30, 9, 0, 0) ||
        Time.zone.local(2016, 4, 30, 13, 0, 0) < Time.zone.now )
  end
  # @@@ def inactive_message, s. http://www.rubydoc.info/github/plataformatec/devise/master/Devise/Models/Authenticatable
  # https://github.com/plataformatec/devise/wiki/How-To%3a-Customize-user-account-status-validation-when-logging-in

  def set_default_role
    self.role ||= :seller
  end

  def name
    "#{first_name} #{last_name}"
  end

  def description
    "#{name} (#{email})"
  end

  def seller_code
    seller && seller.code
  end

  def seller_color
    seller && seller.color
  end

  def seller_number
    seller && seller.number
  end
end
