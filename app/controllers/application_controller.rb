class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticated_user?
  before_filter :user_permission?

  def authenticated_user?
    if !session[:username]
      redirect_to "/login"
    end
  end

  def user_permission?
    if current_user
      if current_user.user_level == User::BASE
        redirect_to "/"
      end
    end
  end

  def current_user
   @current_user ||= User.where(:username => session[:username]).first if session[:username]
  end
  helper_method :current_user

end
