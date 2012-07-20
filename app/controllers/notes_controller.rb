class NotesController < ApplicationController
  skip_before_filter :user_permission?, :only => [:index,:general,:bookings,:clients,:horses,:staff,:show]

  def index
  end

  def general
  end

  def bookings
  end

  def clients
  end

  def horses
  end

  def staff
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