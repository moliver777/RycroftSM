class NotesController < ApplicationController
  skip_before_filter :user_permission?, :except => [:new,:edit,:create,:update,:destroy]

  def index
  end

  def general
  end

  def bookings
  end

  def show_booking
    render "bookings"
  end

  def clients
  end

  def show_client
    render "clients"
  end

  def horses
  end

  def show_horse
    render "horses"
  end

  def staff
  end

  def show_staff
    render "staff"
  end

  def new
  end

  def edit
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end
end