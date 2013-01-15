class User < ActiveRecord::Base
  require "devise/models/authenticatable.rb"
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me
  attr_accessible :mu, :sigma, :is_queued
  attr_protected :is_admin, :is_mod
  has_many :position
  def enqueue!
    self.is_queued = true
    self.save
    return Game.check_queue!
  end
  def dequeue!
    self.is_queued = false
    self.save
  end

  def set_rating!(rating)
    ret = {"old" => {"mu" => self.mu,   "sigma" => self.sigma},  
           "new" => {"mu" => rating.mu, "sigma" => rating.sigma}}
    self.mu, self.sigma = [rating.mu, rating.sigma]
    self.save
    return ret
  end


end
