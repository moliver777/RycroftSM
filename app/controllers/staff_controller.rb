class StaffController < ApplicationController
  skip_before_filter :user_permission?, :only => [:index]

  def index
    @staff = Staff.order("last_name")
  end

  def sort
    @staff = Staff.order(params[:sort]+" "+params[:mod]+", last_name")
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
    staff.notes.destroy_all
    staff.destroy
    render :nothing => true
  end

  private

  def validation fields, id
    @errors = []
    @errors << "Staff must have a first name." unless fields[:first_name].length > 0
    @errors << "Staff must have a last name." unless fields[:last_name].length > 0
    if fields[:date_of_birth].length > 0
      begin
        throw "dob error" unless fields[:date_of_birth].match(/[0-2][0-9]{3}-[0-1][0-9]-[0-3][0-9]/)
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