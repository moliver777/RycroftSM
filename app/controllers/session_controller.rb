class SessionController < ApplicationController

  skip_before_filter :authenticated_user?

  def login
  end

  def create
    user = User.where(:username => params[:username]).first
    if user
      session[:username] = user.username if params[:password] == user.password
    end
    redirect_to root_path
  end

  def destroy
    session[:username] = nil
    redirect_to root_path
  end
end