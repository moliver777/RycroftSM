class AdminController < ApplicationController
  before_filter :master_only

  def index
  end

  def settings
    @preferences = Preference.all
    @site_settings = SiteSetting.where(:external => true)
  end

  def update_settings
    params[:prefernces].each do |preference|
      begin
        p = Preference.where(:name => preference[:name]).first
        p.value = preference[:value]
        p.save!
      rescue
      end
    end
    params[:site_settings].each do |site_setting|
      begin
        s = SiteSetting.where(:name => site_setting[:name]).first
        s.value = site_setting[:value]
        s.save!
      rescue
      end
    end
  end

  def master_only
    if current_user
      if current_user.user_level != User::MASTER
        redirect_to "/"
      end
    end
  end
end