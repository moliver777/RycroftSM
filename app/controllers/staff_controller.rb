class StaffController < ApplicationController
  skip_before_filter :user_permission?, :only => [:index]

  def index
  end

  def new
  end

  def edit
  end

  def show
  end

  def remove
  end

  def remove_info
  end

  def create
  end

  def update
  end

  def destroy
  end
end