class AssignmentController < ApplicationController
  skip_before_filter :application_status
  skip_before_filter :setup

  def block
    block = SiteSetting.where(:name => "block_auto_assign_prompt").first
    block.value = Date.today.to_s
    block.save!
    render :nothing => true
  end

  def auto_assign
    json = {}
    # get all bookings with no horse
    # get all available horses with their splits
    # for each booking
      # for each horse with standard <= client standard
        # if booking doesn't have a horse
          # if duration of booking + current_workload not = overworked
          # and not going to be double booked
          # and not going to be in consecutive lessons
            # set horse to booking
          # end
        # end
      # end
      # set json hash with info of what was assigned or not
    # end
    force_status_check
    render :json => json
  end

  private

  def force_status_check
    issues = []
    issues << Booking.status
    issues << Event.status
    issues << Horse.status
    issues << Staff.status
    notes = Note.priority
    issues.flatten.each_with_index do |issue,i|
      issue[:id] = i
      issues[i] = issue
    end
    session[:issues] = issues.flatten # save issues to session
    session[:notes] = notes # save notes to session
  end
end