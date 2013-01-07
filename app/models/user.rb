class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :mu, :sigma
  attr_protected :is_admin, :is_mod
  # has_many :game
  after_initialize :init
  def init
    self.mu ||= 25.0
    self.sigma ||= self.mu / 3.0
  end
end
