class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  enum role: [:seller, :assistant, :admin]
  enum seller_model: [:A, :B, :C, :D]

  has_many :transactions, dependent: :restrict_with_exception

  after_initialize :set_default_role, :if => :new_record?

  validates :seller_model, presence: true
  validates :role, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  def set_default_role
    self.role ||= :seller
  end

  def description
    self.email
  end
end
