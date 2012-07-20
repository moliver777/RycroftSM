class ReportsController < ApplicationController
  skip_before_filter :user_permission?

  def index
  end

  def bookings
  end

  def client
  end

  def horse
  end

  def staff
  end
end