class HomeController < ApplicationController
  skip_before_filter :user_permission?

  def index
  end

  def schedule
  end

  def schedule_date
  end

  def event
  end
end
