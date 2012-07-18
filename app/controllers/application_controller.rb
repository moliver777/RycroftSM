class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticated_user?

  def authenticated_user?
    if !session[:username]
      redirect_to "/login"
    end
  end

  def current_user
   @current_user ||= User.find(session[:username]) if session[:username]
  end
  helper_method :current_user

end
