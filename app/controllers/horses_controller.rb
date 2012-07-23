class HorsesController < ApplicationController
  skip_before_filter :user_permission?, :only => [:index,:availability]

  def index
    @horses = Horse.order("name")
  end

  def sort
    @horses = Horse.order(params[:sort]+" "+params[:mod]+", name")
    view = render_to_string(:partial => "table_contents")
    render :json => view.to_json
  end

  def new
    @horse = Horse.new
  end

  def edit
    @horse = Horse.find(params[:horse_id])
  end

  def availability
    horse = Horse.find(params[:horse_id])
    horse.availability = params[:value] == "true" ? true : false
    horse.save
    render :nothing => true
  end

  def create
    horse = Horse.new
    horse.set_fields params[:fields]
    render :nothing => true
  end

  def update
    horse = Horse.find(params[:horse_id])
    horse.set_fields params[:fields]
    render :nothing => true
  end

  def destroy
    Horse.find(params[:horse_id]).destroy
    render :nothing => true
  end
end