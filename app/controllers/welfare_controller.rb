class WelfareController < ApplicationController
  def index
    @start = Date.today.at_beginning_of_week
    @end = Date.today.at_beginning_of_week.next_week
    if params.include? :date
      @start = Date.parse(params[:date]).at_beginning_of_week
      @end = Date.parse(params[:date]).at_beginning_of_week.next_week
    end
    build_week_events
  end

  def calendar
    @start = Date.today.at_beginning_of_month
    @end = Date.today.at_beginning_of_month.next_month
    if params.include? :date
      @start = Date.parse(params[:date]).at_beginning_of_month
      @end = Date.parse(params[:date]).at_beginning_of_month.next_month
    end
    @display = @start.at_beginning_of_week
    build_month_events
  end

  def horses
    @horses = Horse.order("name")
  end

  def update
    Horse.all.each do |horse|
      params["welfare"][horse.id.to_s].each do |key, value|
        horse.send "#{key}=", value
      end
      horse.save
    end
    render :nothing => true
  end

  private

  def build_week_events
    @horses = Horse.all
    @week_events = {}
    @horses.each do |horse|
      event_in_week(horse, horse.farrier_date, horse.farrier_repeat, horse.farrier_repeat_type, "farrier") if horse.farrier_enabled
      event_in_week(horse, horse.worming_date, horse.worming_repeat, horse.worming_repeat_type, "worming") if horse.worming_enabled
      event_in_week(horse, horse.dentist_date, horse.dentist_repeat, horse.dentist_repeat_type, "dentist") if horse.dentist_enabled
      event_in_week(horse, horse.physio_date, horse.physio_repeat, horse.physio_repeat_type, "physio") if horse.physio_enabled
      event_in_week(horse, horse.vaccination_date, horse.vaccination_repeat, horse.vaccination_repeat_type, "vaccination") if horse.vaccination_enabled
      event_in_week(horse, horse.other_date, horse.other_repeat, horse.other_repeat_type, "other") if horse.other_enabled
    end
  end

  def build_month_events
    @horses = Horse.all
    @month_events = {}
    @horses.each do |horse|
      event_in_month(horse, horse.farrier_date, horse.farrier_repeat, horse.farrier_repeat_type, "farrier") if horse.farrier_enabled
      event_in_month(horse, horse.worming_date, horse.worming_repeat, horse.worming_repeat_type, "worming") if horse.worming_enabled
      event_in_month(horse, horse.dentist_date, horse.dentist_repeat, horse.dentist_repeat_type, "dentist") if horse.dentist_enabled
      event_in_month(horse, horse.physio_date, horse.physio_repeat, horse.physio_repeat_type, "physio") if horse.physio_enabled
      event_in_month(horse, horse.vaccination_date, horse.vaccination_repeat, horse.vaccination_repeat_type, "vaccination") if horse.vaccination_enabled
      event_in_month(horse, horse.other_date, horse.other_repeat, horse.other_repeat_type, "other") if horse.other_enabled
    end
  end

  def event_in_week horse, due, repeat, interval, type
    begin
      if repeat > 0
        while due < @end
          if due >= @start
            @week_events[type] ||= []
            @week_events[type] << horse
          end
          due = due_interval due, repeat, interval
        end
      else
        if due >= @start && due < @end
          @week_events[type] ||= []
          @week_events[type] << horse
        end
      end
    rescue StandardError => e
      puts "Failed to parse #{type} event for horse #{horse.id} in week view"
      puts e.message
      puts e.backtrace
    end
  end

  def event_in_month horse, due, repeat, interval, type
    begin
      if repeat > 0
        while due < @end
          if due >= @start
            @month_events[due.to_s] ||= {}
            @month_events[due.to_s][type] ||= []
            @month_events[due.to_s][type] << horse
          end
          due = due_interval due, repeat, interval
        end
      else
        if due >= @start && due < @end
          @month_events[due.to_s] ||= {}
          @month_events[due.to_s][type] ||= []
          @month_events[due.to_s][type] << horse
        end
      end
    rescue StandardError => e
      puts "Failed to parse #{type} event for horse #{horse.id} in month view"
      puts e.message
      puts e.backtrace
    end
  end

  def due_interval due, repeat, interval
    case interval
    when "day"
      return due.advance(:days => repeat)
    when "week"
      return due.advance(:weeks => repeat)
    when "month"
      return due.advance(:months => repeat)
    when "year"
      return due.advance(:years => repeat)
    else
      return due.advance(:weeks => repeat)
    end
  end
end