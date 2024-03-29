class ReportsController < ApplicationController
  skip_before_action :user_permission?

  def index
    @from = Date.today.advance(:days => -7)
    @to = Date.today.advance(:days => 7)
    horse_workloads
    staff_workloads
    horse_events
    client_ages
    client_events
    # client_standards
    event_types
    bookings_by_day
    bookings_by_hour
  end

  def change_date
    @from = params[:from_date]
    @to = params[:to_date]
    horse_workloads
    staff_workloads
    horse_events
    client_ages
    client_events
    # client_standards
    event_types
    bookings_by_day
    bookings_by_hour
    render :json => {:view => render_to_string(:partial => "reports")}
  end

end
