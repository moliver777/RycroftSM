class VenuesController < ApplicationController
  before_filter :master_only

  def index
    @venues = Venue.order("name")
  end

  def new
    @venue = Venue.new
  end

  def edit
    @venue = Venue.find(params[:venue_id])
  end

  def create
    venue = Venue.new
    venue.set_fields params[:fields]
    render :nothing => true
  end

  def update
    venue = Venue.find(params[:venue_id])
    venue.set_fields params[:fields]
    render :nothing => true
  end

  def destroy
    Venue.find(params[:venue_id]).destroy
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