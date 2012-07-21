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

  def edit
    @staff = Staff.find(params[:staff_id])
  end

  def create
    staff = Staff.new
    staff.set_fields params[:fields]
    render :nothing => true
  end

  def update
    staff = Staff.find(params[:staff_id])
    staff.set_fields params[:fields]
    render :nothing => true
  end

  def destroy
    Staff.find(params[:staff_id]).destroy
    render :nothing => true
  end
end