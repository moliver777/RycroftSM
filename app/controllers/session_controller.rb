class SessionController < ApplicationController
  skip_before_action :authenticated_user?
  skip_before_action :user_permission?
  skip_before_action :setup
  skip_before_action :format_date

  def login
    session[:username] = nil
    @error = session[:error] if session[:error]
    render :layout => "login"
  end

  def create
    user = User.where(:username => params[:username]).first
    if user
      if params[:password] == User.decrypt(user.password)
        session[:username] = user.username
        session[:error] = nil
      else
        session[:error] = "Incorrect username and/or password"
      end
    else
      session[:error] = "Incorrect username and/or password"
    end
    redirect_to root_path
  end

  def destroy
    session[:username] = nil
    session[:error] = nil
    redirect_to root_path
  end
end
