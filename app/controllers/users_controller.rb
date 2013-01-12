class UsersController < ApplicationController
  before_filter :authenticate_user!
  def enqueue
    if current_user.enqueue!
      respond_to do |format|
        format.html
        format.json { render :json => Game.last }
      end
    else 
      respond_to do |format|
        format.html
        format.json { render :json => User.where(:is_queued => true) }
      end
    end
  end
  def dequeue
    current_user.dequeue!
  end
end
