class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticated_user?
  before_filter :user_permission?
  before_filter :application_status

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

  def application_status
    timer = SiteSetting.where(:name => "application_status_check").first
    if timer.updated_at < Time.now.advance(:minutes => -1)
      timer.value = timer.value.to_i == 999 ? 0.to_s : (timer.value.to_i + 1).to_s
      timer.save!
      # DO CHECK HERE
      session[:issues] = {} # save issues to session
      session[:notes] = {} # save notes to session
    end
    @status_issues = session[:issues] rescue {} # make session issues available to views
    @status_notes = session[:notes] rescue {} # make session notes available to views
  end

  def current_user
   @current_user ||= User.where(:username => session[:username]).first if session[:username]
  end
  helper_method :current_user

end
