class UsersController < ApplicationController
  before_filter :authenticate_user!
  helper_method :magic_user
  def magic_user
    if (current_user.is_admin and params[:fake_user]) 
      User.find(params[:fake_user])
    else
      current_user
    end
  end
            
  def enqueue
    if magic_user.enqueue!
      @game = Game.last
      render 'games/game'
    else 
      @queue = User.where(:is_queued => true)
      render 'users/queue'
    end
  end

  def dequeue
    magic_user.dequeue!
      @queue = User.where(:is_queued => true)
      render 'users/queue'
  end

  def token
    @token = magic_user.authentication_token
    render 'users/token'
  end
end
