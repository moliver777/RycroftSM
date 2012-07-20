class AdminController < ApplicationController
  before_filter :master_only

  def index
  end

  def preferences
  end

  def update_preferences
  end

  def site_settings
  end

  def update_site_settings
  end

  def master_only
    if current_user
      if current_user.user_level != User::MASTER
        redirect_to "/"
      end
    end
  end
end