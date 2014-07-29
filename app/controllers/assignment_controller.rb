class AssignmentController < ApplicationController
  skip_before_filter :setup

  def block
    block = SiteSetting.where(:name => "block_auto_assign_prompt").first
    block.value = Date.today.to_s
    block.save!
    render :nothing => true
  end

  def auto_assign
    session[:upcoming] = params[:date]
    data = {}
    count = 0
    assign_ids = Event.where("event_date = ? AND event_type IN (?) AND cancelled = ?", params[:date], Event::HORSE, false).order("start_time").map{|e| e.bookings.where(:cancelled => false)}.flatten.select{|b| !b.horse}.map{|b| b.id}
    while assign_ids[0] && count < 3
      booking = Booking.where(:id => assign_ids[0]).first
      leased = Horse.where(hidden: false, id: booking.client.leasing).first
      if leased
        if !leased.over_workload(params[:date], booking.event.duration_mins) && leased.availability
          if validate_assignment(booking, leased, false)
            booking.horse_id = leased.id
          end
        end
        key = "#{booking.event.start_time.strftime("%l:%M%P")} #{booking.event.event_type.downcase.capitalize} - #{booking.client.first_name} #{booking.client.last_name}"
        data[key] = booking.horse ? booking.horse.name : "No suitable horse found!"
        booking.save!
      end
      unless booking.horse
        horses = get_suitable_horses(booking.client)
        if horses.length > 0
          horses.each do |horse|
            unless booking.horse
              unless horse.over_workload(params[:date], booking.event.duration_mins)
                if validate_assignment(booking, horse)
                  booking.horse_id = horse.id
                end
              end
            end
          end
          key = "#{booking.event.start_time.strftime("%l:%M%P")} #{booking.event.event_type.downcase.capitalize} - #{booking.client.first_name} #{booking.client.last_name}"
          data[key] = booking.horse ? booking.horse.name : "No suitable horse found!"
          booking.save!
        else
          key = "#{booking.event.start_time.strftime("%l:%M%P")} #{booking.event.event_type.downcase.capitalize} - #{booking.client.first_name} #{booking.client.last_name}"
          data[key] = "N/A"
        end
      end
      count += 1
      assign_ids.shift
    end
    session[:assign_ids] = assign_ids.join(";")
    # force_status_check unless assign_ids[0]
    render :json => {:bookings => data, :remaining => assign_ids.count}.to_json
  end

  def continue_assign
    data = {}
    count = 0
    assign_ids = session[:assign_ids].split(";")
    while assign_ids[0] && count < 3
      booking = Booking.where(:id => assign_ids[0]).first
      leased = Horse.where(hidden: false, id: booking.client.leasing).first
      if leased
        if !leased.over_workload(params[:date], booking.event.duration_mins) && leased.availability
          if validate_assignment(booking, leased, false)
            booking.horse_id = leased.id
          end
        end
        key = "#{booking.event.start_time.strftime("%l:%M%P")} #{booking.event.event_type.downcase.capitalize} - #{booking.client.first_name} #{booking.client.last_name}"
        data[key] = booking.horse ? booking.horse.name : "No suitable horse found!"
        booking.save!
      end
      unless booking.horse
        horses = get_suitable_horses(booking.client)
        if horses.length > 0
          horses.each do |horse|
            unless booking.horse
              unless horse.over_workload(params[:date], booking.event.duration_mins)
                if validate_assignment(booking, horse)
                  booking.horse_id = horse.id
                end
              end
            end
          end
          key = "#{booking.event.start_time.strftime("%l:%M%P")} #{booking.event.event_type.downcase.capitalize} - #{booking.client.first_name} #{booking.client.last_name}"
          data[key] = booking.horse ? booking.horse.name : "No suitable horse found!"
          booking.save!
        else
          key = "#{booking.event.start_time.strftime("%l:%M%P")} #{booking.event.event_type.downcase.capitalize} - #{booking.client.first_name} #{booking.client.last_name}"
          data[key] = "N/A"
        end
      end
      count += 1
      assign_ids.shift
    end
    session[:assign_ids] = assign_ids.join(";")
    # force_status_check unless assign_ids[0]
    render :json => {:bookings => data, :remaining => assign_ids.count}.to_json
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
    session[:issues] = issues.flatten
    session[:notes] = notes
    timer = SiteSetting.where(:name => "application_status_check").first
    timer.value = timer.value.to_i == 999 ? 0.to_s : (timer.value.to_i + 1).to_s
    timer.save!
  end

  def get_suitable_horses client
    Horse.where("hidden = false AND availability = true AND id IN (?)", client.horses.split(";")).shuffle.sort_by{|h| h.current_mins(params[:date])} rescue []
  end

  def get_splits horse, evt
    event_splits = []
    booking_splits = []
    booking_splits << evt.start_time.strftime("%H:%M")
    hour = evt.start_time.strftime("%H")
    mins = evt.start_time.strftime("%M")
    while hour.to_s+":"+mins.to_s != evt.end_time.strftime("%H:%M")
      mins = mins.to_i+15
      if mins == 60
        mins = "00"
        hour = hour.to_i+1
        hour = "0"+hour.to_s if hour < 10
      end
      booking_splits << hour.to_s+":"+mins.to_s
    end
    horse.events.where(:event_date => params[:date], :cancelled => false).each do |event|
      splits = []
      splits << event.start_time.strftime("%H:%M")
      hour = event.start_time.strftime("%H")
      mins = event.start_time.strftime("%M")
      while hour.to_s+":"+mins.to_s != event.end_time.strftime("%H:%M")
        mins = mins.to_i+15
        if mins == 60
          mins = "00"
          hour = hour.to_i+1
          hour = "0"+hour.to_s if hour < 10
        end
        splits << hour.to_s+":"+mins.to_s
      end
      event_splits << splits
    end
    [event_splits, booking_splits]
  end

  def validate_assignment booking, horse, full_check=true
    valid = true
    # test for consecutive lessons (first of any splits array == last of any splits array)
    splits = get_splits(horse, booking.event)
    event_splits = splits[0]
    booking_splits = splits[1]
    if full_check
      event_splits.each do |event|
        valid = false if booking_splits.first == event.last || booking_splits.last == event.first
      end
    end
    # test for overlap of lessons
    booking_splits.each do |split|
      event_splits.each do |event|
        event.each do |split2|
          if split2 != event.first && split2 != event.last
            valid = false if split == split2
          end
        end
      end
    end
    # test for double booking
    horse.bookings.where(:cancelled => false).each do |booking2|
      valid = false if booking.event == booking2.event
    end
    if full_check
      # test for group status
      if Event::GROUP_TYPES.include?(booking.event.event_type) || booking.event.bookings.count > 1
        valid = false unless horse.group
      end
      # test for bhs stage
      if Event::BHS_TYPES.include? booking.event.event_type
        valid = false unless horse.bhs >= booking.event.event_type.split(" ")[1].to_i
      end
    end
    valid
  end
end