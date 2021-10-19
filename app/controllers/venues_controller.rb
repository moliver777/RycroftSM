class VenuesController < ApplicationController
  before_action :master_only

  def index
    @venues = Venue.where(:master => true).order("name")
  end

  def new
    @venue = Venue.new
  end

  def create
    validation params[:fields], 0
    if @validated
      params[:fields][:capacity].to_i.times do |i|
        venue = Venue.new
        venue.set_fields params[:fields], (i==0)
      end
    end
    render :json => @errors.to_json
  end

  def destroy
    venue = Venue.find(params[:venue_id])
    Venue.where(:name => venue.name).destroy_all
    render :nothing => true
  end

  def master_only
    if current_user
      if current_user.user_level != User::MASTER
        redirect_to "/"
      end
    end
  end

  private

  def validation fields, id
    @errors = []
    @errors << "Venue must have a name." unless fields[:name].length > 0
    @errors << "Venue capacity must be greater than 0" unless fields[:capacity].to_i > 0
    @validated = @errors.length > 0 ? false : true
  end
end
