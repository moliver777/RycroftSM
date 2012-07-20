class WelfareController < ApplicationController
  skip_before_filter :user_permission?, :only => [:index,:show]

  def index
  end

  def show
  end

  def edit
  end

  def update
  end
end