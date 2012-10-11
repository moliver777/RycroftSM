class NotesController < ApplicationController
  skip_before_filter :user_permission?, :except => [:new,:edit,:create,:update,:destroy]
  skip_before_filter :application_status, :except => [:index,:general,:bookings,:clients,:horses,:staff]

  def index
    @notes = Note.where(:repeated => false).order("urgent DESC, end_date DESC")
  end

  def general
    @notes = Note.where(:category => Note::GENERAL, :repeated => false).order("urgent DESC, end_date DESC")
  end

  def bookings
    @notes = Note.where(:category => Note::BOOKING, :repeated => false).order("urgent DESC, end_date DESC")
  end

  def show_booking
    @booking = Booking.find(params[:booking_id])
    @event = @booking.event
    @notes = Note.where(:booking_id => params[:booking_id], :repeated => false).order("urgent DESC, end_date DESC")
    render "bookings"
  end

  def clients
    @notes = Note.where(:category => Note::CLIENT, :repeated => false).order("urgent DESC, end_date DESC")
  end

  def show_client
    @client = Client.find(params[:client_id])
    @notes = Note.where(:client_id => params[:client_id], :repeated => false).order("urgent DESC, end_date DESC")
    render "clients"
  end

  def horses
    @notes = Note.where(:category => Note::HORSE, :repeated => false).order("urgent DESC, end_date DESC")
  end

  def show_horse
    @horse = Horse.find(params[:horse_id])
    @notes = Note.where(:horse_id => params[:horse_id], :repeated => false).order("urgent DESC, end_date DESC")
    render "horses"
  end

  def staff
    @notes = Note.where(:category => Note::STAFF, :repeated => false).order("urgent DESC, end_date DESC")
  end

  def show_staff
    @staff = Staff.find(params[:staff_id])
    @notes = Note.where(:staff_id => params[:staff_id], :repeated => false).order("urgent DESC, end_date DESC")
    render "staff"
  end

  def new
    @category = params[:category] if params[:category]
    if @category && params[:subject_id]
      case @category
      when Note::BOOKING
        @subject = Booking.find(params[:subject_id])
      when Note::CLIENT
        @subject = Client.find(params[:subject_id])
      when Note::HORSE
        @subject = Horse.find(params[:subject_id])
      when Note::STAFF
        @subject = Staff.find(params[:subject_id])
      end
    end
    load_subjects
    @note = Note.new
  end

  def edit
    load_subjects
    @note = Note.find(params[:note_id])
    @category = @note.category
    case @category
    when Note::BOOKING
      @subject = @note.booking
    when Note::CLIENT
      @subject = @note.client
    when Note::HORSE
      @subject = @note.horse
    when Note::STAFF
      @subject = @note.staff
    end
  end

  def create
    validation params[:fields], 0
    if @validated
      note = Note.new
      note.set_fields params[:fields]
    end
    render :json => @errors.to_json
  end

  def update
    validation params[:fields], 0
    if @validated
      note = Note.find(params[:note_id])
      note.set_fields params[:fields]
    end
    render :json => @errors.to_json
  end

  def destroy
    Note.find(params[:note_id]).destroy
    render :nothing => true
  end

  def hide
    note = Note.find(params[:note_id])
    note.hidden = true
    note.save!
    redirect_to "/"
  end

  private

  def load_subjects
    @bookings = Booking.includes(:event).where("events.event_date >= ?", Date.today).order("events.event_date")
    @clients = Client.order("last_name")
    @horses = Horse.order("name")
    @staff = Staff.order("last_name")
  end

  def validation fields, id
    @errors = []
    @errors << "Note must have a title." unless fields[:title].length > 0
    @errors << "Note must have some content." unless fields[:content].length > 0
    @errors << "Note must have a category." if fields[:category] == "0"
    @errors << "Note must have a start and end date." unless Date.parse(fields[:start_date]) && Date.parse(fields[:end_date])
    case fields[:category]
    when Note::BOOKING
      @errors << "Booking category must be linked to a booking." if fields[:booking_id] == "0"
    when Note::CLIENT
      @errors << "Client category must be linked to a client." if fields[:client_id] == "0"
    when Note::HORSE
      @errors << "Horse category must be linked to a horse." if fields[:horse_id] == "0"
    when Note::STAFF
      @errors << "Instructor category must be linked to an instructor." if fields[:staff_id] == "0"
    end
    @validated = @errors.length > 0 ? false : true
  end
end