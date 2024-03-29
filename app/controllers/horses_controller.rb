class HorsesController < ApplicationController
  skip_before_action :user_permission?, :only => [:index,:show,:availability]

  def index
    @horses = Horse.where(hidden: false).order("name")
  end

  def leased
    @leases = {}
    Client.where(hidden: false).each do |client|
      horse = Horse.where(hidden: false, id: client.leasing).first
      if horse
        @leases[horse.name] = "#{client.first_name if client.first_name} #{client.last_name if client.last_name}"
      end
    end
  end

  def sort
    @horses = Horse.where(hidden: false).order(params[:sort]+" "+params[:mod]+", name")
    view = render_to_string(:partial => "table_contents")
    render :json => view.to_json
  end

  def new
    @horse = Horse.new
  end

  def show
    @horse = Horse.find(params[:horse_id])
  end

  def edit
    @horse = Horse.find(params[:horse_id])
  end

  def availability
    horse = Horse.find(params[:horse_id])
    if params[:value] == "true"
      horse.availability = true
    else
      horse.availability = false
      horse.bookings.includes(:event).where("events.event_date > ?", Date.today).update_all({:horse_id => nil})
    end
    horse.save
    render :nothing => true
  end

  def exercise
    horse = Horse.find(params[:horse_id])
    horse.exercise = params[:value] == "true" ? true : false
    horse.save
    render :nothing => true
  end

  def create
    validation params[:fields], 0
    if @validated
      horse = Horse.new
      horse.set_fields params[:fields]
      note = Note.new
      note.title = "Horse must have an Assessment"
      note.content = "All new horses must undertake an assessment."
      note.urgent = true
      note.category = "HORSE"
      note.horse_id = horse.id
      note.start_date = Date.today
      note.end_date = Date.today.advance(:years => 1)
      note.save!
    end
    render :json => @errors.to_json
  end

  def update
    validation params[:fields], 0
    if @validated
      horse = Horse.find(params[:horse_id])
      horse.set_fields params[:fields]
    end
    render :json => @errors.to_json
  end

  def destroy
    horse = Horse.find(params[:horse_id])
    horse.bookings.includes(:event).where("events.event_date > ?", Date.today).each do |b|
      b.horse_id = nil
      b.save!
    end
    horse.notes.destroy_all
    horse.update_attribute(:hidden, true)
    # horse.destroy
    render :nothing => true
  end

  private

  def validation fields, id
    @errors = []
    @errors << "Horse must have a name." unless fields[:name].length > 0
    @errors << "Max day workload must be between 1 and 24 hours." unless fields[:max_day_workload].to_i > 0 && fields[:max_day_workload].to_i < 25
    @validated = @errors.length > 0 ? false : true
  end
end
