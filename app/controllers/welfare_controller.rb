class WelfareController < ApplicationController
  before_filter :welfare_user?

  def index
  end

  def calendar
  end

  def lists
  end

  private

  def welfare_user?
    redirect_to "/" unless current_user.username == @welfare_user
  end
end