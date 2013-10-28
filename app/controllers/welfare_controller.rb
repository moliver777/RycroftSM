class WelfareController < ApplicationController
  def index
    @horses = Horse.all
    @start = Date.today.at_beginning_of_week
    @end = Date.today.at_beginning_of_week.next_week
    build_due_events
  end

  def calendar
    @horses = Horse.all
    @start = Date.today.at_beginning_of_month
    @end = Date.today.at_beginning_of_month.next_month
    build_due_events
  end

  def horses
    @horses = Horse.all
  end

  def week_change
    @horses = Horse.all
    @start = 
    @end = 
  end

  def month_change
    @horses = Horse.all
    @start = 
    @end = 
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

  def build_due_events
    @due_events = {}
  end
end