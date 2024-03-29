class StaffController < ApplicationController
  skip_before_action :user_permission?, :only => [:index,:show]

  def index
    @staff = Staff.where(hidden: false).order("first_name, last_name")
  end

  def sort
    @staff = Staff.where(hidden: false).order(params[:sort]+" "+params[:mod]+", first_name, last_name")
    view = render_to_string(:partial => "table_contents")
    render :json => view.to_json
  end

  def new
    @staff = Staff.new
  end

  def show
    @staff = Staff.find(params[:staff_id])
  end

  def edit
    @staff = Staff.find(params[:staff_id])
  end

  def create
    validation params[:fields], 0
    if @validated
      staff = Staff.new
      staff.set_fields params[:fields]
    end
    render :json => @errors.to_json
  end

  def update
    validation params[:fields], params[:staff_id]
    if @validated
      staff = Staff.find(params[:staff_id])
      staff.set_fields params[:fields]
    end
    render :json => @errors.to_json
  end

  def destroy
    staff = Staff.find(params[:staff_id])
    staff.events.where("event_date > ?", Date.today).each do |e|
      e.staff_id = nil
      e.save!
    end
    staff.notes.destroy_all
    staff.update_attribute(:hidden, true)
    # staff.destroy
    render :nothing => true
  end

  private

  def validation fields, id
    @errors = []
    @errors << "Instructor must have a first name." unless fields[:first_name].length > 0
    @errors << "Instructor must have a last name." unless fields[:last_name].length > 0
    if fields[:date_of_birth].length > 0
      begin
        Date.parse(fields[:date_of_birth])
      rescue
        @errors << "Date of birth is invalid."
      end
    end
    if fields[:home_phone].length > 0
      @errors << "Home phone number is invalid." unless fields[:home_phone].match(/[0-9]{6,}/)
      @errors << "Home phone number is invalid." if fields[:home_phone].match(/\D/)
    end
    if fields[:mobile_phone].length > 0
      @errors << "Mobile phone number is invalid." unless fields[:mobile_phone].match(/[0-9]{6,}/)
      @errors << "Mobile phone number is invalid." if fields[:mobile_phone].match(/\D/)
    end
    @validated = @errors.length > 0 ? false : true
  end
end
