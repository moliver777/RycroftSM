class UsersController < ApplicationController
  before_filter :master_only

  def index
    users = User.order("last_name")
    @users = []
    User::LEVELS.reverse.each do |lvl|
      users.each{|u| @users << u if u.user_level==lvl && u.username!="admin"}
    end
  end

  def new
    @user = User.new
  end

  def edit
    redirect_to "/admin/users" if params[:username] == "admin"
    @user = User.where(:username => params[:username]).first
  end

  def reset_password
    redirect_to "/admin/users" if params[:username] == "admin"
    user = User.where(:username => params[:username]).first
    user.reset_password
    render :nothing => true
  end

  def create
    user = User.new
    user.set_fields params[:fields]
    render :nothing => true
  end

  def update
    redirect_to "/admin/users" if params[:username] == "admin"
    user = User.where(:username => params[:username]).first
    user.set_fields params[:fields]
    render :nothing => true
  end

  def destroy
    redirect_to "/admin/users" if params[:username] == "admin"
    User.where(:username => params[:username]).first.destroy
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