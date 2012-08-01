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
    validation params[:fields], 0
    if @validated
      venue = Venue.new
      venue.set_fields params[:fields]
    end
    render :json => @errors.to_json
  end

  def update
    validation params[:fields], params[:venue_id]
    if @validated
      venue = Venue.find(params[:venue_id])
      venue.set_fields params[:fields]
    end
    render :json => @errors.to_json
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

  private

  def validation fields, id
    @errors = []
    @errors << "Venue must have a name." unless fields[:name].length > 0
    @errors << "There is already a venue with that name." if Venue.where("name = ? and id != ?", fields[:name], id).first
    @validated = @errors.length > 0 ? false : true
  end
end