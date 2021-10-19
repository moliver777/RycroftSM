class AdminController < ApplicationController
  before_action :master_only, :except => :index

  def index
  end

  def settings
    @preferences = Preference.where("name != 'price_list'")
    @price_list = Preference.where(:name => "price_list").first.value rescue "No Price List found!"
    @site_settings = SiteSetting.all
  end

  def update_settings
    params[:preferences].each do |preference|
      begin
        pref = Preference.where(:name => preference[0]).first
        pref.value = preference[1]
        pref.save!
      rescue
      end
    end
    params[:site_settings].each do |setting|
      begin
        sset = SiteSetting.where(:name => setting[0]).first
        sset.value = setting[1].gsub("'","")
        sset.save!
      rescue
      end
    end
    render :nothing => true
  end

  def master_only
    if current_user
      if current_user.user_level != User::MASTER
        redirect_to "/"
      end
    end
  end
end
