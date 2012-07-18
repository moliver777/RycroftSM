class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticated_user?

  def authenticated_user?
    if !session[:username]
      redirect_to "/login"
    end
  end

end
