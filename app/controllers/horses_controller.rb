class HorsesController < ApplicationController
  skip_before_filter :user_permission?, :only => [:index,:availability]

  def index
    @horses = Horse.order("name")
  end

  def sort
    # todo
  end

  def new
    @horse = Horse.new
  end

  def edit
    # todo
  end

  def availability
    horse = Horse.find(params[:horse_id])
    horse.availability = params[:value] == "true" ? true : false
    horse.save
    render :nothing => true
  end

  def create
    # todo
  end

  def update
    # todo
  end

  def destroy
    # todo
  end
end