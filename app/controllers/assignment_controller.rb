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
    bookings = Event.where(:event_date => Date.today).order("start_time").map{|e| e.bookings}.flatten.select{|b| !b.horse}
    bookings.each do |booking|
      horses = get_suitable_horses(booking.client)
      horses.each do |horse|
        if !booking.horse
          if !horse.over_workload(Date.today, booking.event.duration_mins)
            if validate_assignment(booking, horse)
              booking.horse_id = horse.id
            end
          end
        end
      end
      key = "#{booking.event.start_time.strftime("%H:%M")} #{booking.event.name} - #{booking.client.first_name} #{booking.client.last_name}"
      json[key] = booking.horse ? booking.horse.name : "No suitable horse found!"
      booking.save!
    end
    force_status_check
    render :json => json.to_json
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
  end

  def get_suitable_horses client
    horses = []
    beg_horses = Horse.where(:standard => Horse::BEGINNER, :availability => true).order("max_day_workload DESC").sort_by{|h| h.current_mins(Date.today)}
    int_horses = Horse.where(:standard => Horse::INTERMEDIATE, :availability => true).order("max_day_workload DESC").sort_by{|h| h.current_mins(Date.today)}
    adv_horses = Horse.where(:standard => Horse::ADVANCED, :availability => true).order("max_day_workload DESC").sort_by{|h| h.current_mins(Date.today)}
    case client.standard
    when Client::INTERMEDIATE
      horses << int_horses
    when Client::ADVANCED
      horses << adv_horses
      horses << int_horses
    end
    horses << beg_horses
    horses.flatten!
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
    horse.events.where(:event_date => Date.today).each do |event|
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

  def validate_assignment booking, horse
    valid = true
    # test for consecutive lessons (first of any splits array == last of any splits array)
    splits = get_splits(horse, booking.event)
    event_splits = splits[0]
    booking_splits = splits[1]
    event_splits.each do |event|
      valid = false if booking_splits.first == event.last || booking_splits.last == event.first
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
    horse.bookings.each do |booking2|
      valid = false if booking.event == booking2.event
    end
    valid
  end
end