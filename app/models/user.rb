class User < ActiveRecord::Base
  @@max_sellers = 105
  @@max_model_a = 25
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

  validates :seller_model, presence: true, if: :seller?
  validates :seller_model, absence: true, unless: :seller?
  validates :role, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  validate :seller_model_available
  validate :seller_available


  def set_default_role
    self.role ||= :seller
  end

  def name
    "#{first_name} #{last_name}"
  end

  def description
    "#{name} (#{email})"
  end

  private

  def seller_available
    if seller? && @@max_sellers <= User.seller.count
      errors.clear
      errors[:base] << "Anmeldung nicht mehr möglich"
    end
  end

  def seller_model_available
    if seller?
      if D?
        if @@max_model_d <= User.seller.D.count
          errors.add :seller_model, "D nicht mehr verfügbar"
        end
      else
        if @@max_sellers - @@reserved_model_d <= User.seller.where.not(seller_model: User.seller_models[:D]).count
          errors.add :seller_model, "#{seller_model} nicht mehr verfügbar (nur noch D verfügbar)"
        elsif A? && @@max_model_a <= User.seller.A.count
          errors.add :seller_model, "A nicht mehr verfügbar"
        end
      end
    end
  end
end
