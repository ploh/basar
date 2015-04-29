class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  enum role: [:seller, :assistant, :admin]

  has_many :transactions, dependent: :restrict_with_exception

  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :seller
  end
end
