class UsersController < ApplicationController
  before_filter :master_only

  def index
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  def master_only
    if current_user
      if current_user.user_level != User::MASTER
        redirect_to "/"
      end
    end
  end
end