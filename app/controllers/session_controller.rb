class SessionController < ApplicationController

  skip_before_filter :authenticated_user?

  def login
    @error = session[:error] if session[:error]
    render :layout => "login"
  end

  def create
    user = User.where(:username => session[:username]).first
    if user
      p user
      if params[:password] == user.password
        p user.password
        p params[:password] == user.password ? 'true' : 'false'
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