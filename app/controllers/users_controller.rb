class UsersController < ApplicationController
  before_filter :authenticate_user!
  helper_method :magic_user, :render_game
  def magic_user
    if (current_user.is_admin and params[:fake_user]) 
      User.find(params[:fake_user])
    else
      current_user
    end
  end

  def queue
    @queue = User.where(:is_queued => true)
    render 'users/queue'
  end

  def enqueue
    @game = magic_user.enqueue!
    if @game
      render 'games/game'
    else 
      return queue
    end
  end

  def dequeue
    magic_user.dequeue!
    return queue
  end

  def accept
    @game = magic_user.accept!
    render 'games/game'
  end

  def decline
    @game = magic_user.decline!
    if @game
      render 'games/game'
    else
      return queue
    end
  end

  def token
    render 'users/token'
  end

  def reset_token
    magic_user.reset_authentication_token!
    render 'users/token'
  end
end
