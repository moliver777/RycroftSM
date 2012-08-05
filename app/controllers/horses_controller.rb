class HorsesController < ApplicationController
  skip_before_filter :user_permission?, :only => [:index,:show,:availability]

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

  def show
    @horse = Horse.find(params[:horse_id])
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
    validation params[:fields], 0
    if @validated
      horse = Horse.new
      horse.set_fields params[:fields]
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
    horse.notes.destroy_all
    horse.destroy
    render :nothing => true
  end

  private

  def validation fields, id
    @errors = []
    @errors << "Horse must have a name." unless fields[:name].length > 0
    @errors << "Horse must have a riding standard." if fields[:standard] == "0"
    @errors << "Max day workload must be between 1 and 24 hours." unless fields[:max_day_workload].to_i > 0 && fields[:max_day_workload].to_i < 25
    if fields[:farrier] == "true"
      if fields[:farrier_date].length > 0
        begin
          throw "date error" unless fields[:farrier_date].match(/[0-2][0-9]{3}-[0-1][0-9]-[0-3][0-9]/)
          Date.parse(fields[:farrier_date])
        rescue
          @errors << "Farrier start date is invalid."
        end
      else
        @errors << "No start date for farrier."
      end
      @errors << "Farrier frequency weeks must be a number greater than 0." unless fields[:farrier_freq].to_i > 0
    end
    if fields[:worming] == "true"
      if fields[:worming_date].length > 0
        begin
          throw "date error" unless fields[:worming_date].match(/[0-2][0-9]{3}-[0-1][0-9]-[0-3][0-9]/)
          Date.parse(fields[:worming_date])
        rescue
          @errors << "Worming start date is invalid."
        end
      else
        @errors << "No start date for worming."
      end
      @errors << "Worming frequency weeks must be a number greater than 0." unless fields[:worming_freq].to_i > 0
    end
    if fields[:vet] == "true"
      if fields[:vet_date].length > 0
        begin
          throw "date error" unless fields[:vet_date].match(/[0-2][0-9]{3}-[0-1][0-9]-[0-3][0-9]/)
          Date.parse(fields[:vet_date])
        rescue
          @errors << "Vet start date is invalid."
        end
      else
        @errors << "No start date for vet."
      end
      @errors << "Vet frequency weeks must be a number greater than 0." unless fields[:vet_freq].to_i > 0
    end
    if fields[:medication] == "true"
      if fields[:medication_date].length > 0
        begin
          throw "date error" unless fields[:medication_date].match(/[0-2][0-9]{3}-[0-1][0-9]-[0-3][0-9]/)
          Date.parse(fields[:medication_date])
        rescue
          @errors << "Medication start date is invalid."
        end
      else
        @errors << "No start date for medication."
      end
      @errors << "Medication frequency weeks must be a number greater than 0." unless fields[:medication_freq].to_i > 0
    end
    @validated = @errors.length > 0 ? false : true
  end
end