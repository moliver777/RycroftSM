class NotesController < ApplicationController
  skip_before_filter :user_permission?, :except => [:new,:edit,:create,:update,:destroy]

  def index
    @notes = Note.order("urgent DESC, updated_at DESC")
  end

  def general
    @notes = Note.where(:category => Note::GENERAL).order("urgent DESC, updated_at DESC")
  end

  def bookings
    @notes = Note.where(:category => Note::BOOKING).order("urgent DESC, updated_at DESC")
  end

  def show_booking
    @booking = Booking.find(params[:booking_id])
    @event = @booking.event
    @notes = Note.where(:booking_id => params[:booking_id]).order("urgent DESC, updated_at DESC")
    render "bookings"
  end

  def clients
    @notes = Note.where(:category => Note::CLIENT).order("urgent DESC, updated_at DESC")
  end

  def show_client
    @client = Client.find(params[:client_id])
    @notes = Note.where(:client_id => params[:client_id]).order("urgent DESC, updated_at DESC")
    render "clients"
  end

  def horses
    @notes = Note.where(:category => Note::HORSE).order("urgent DESC, updated_at DESC")
  end

  def show_horse
    @horse = Horse.find(params[:horse_id])
    @notes = Note.where(:horse_id => params[:horse_id]).order("urgent DESC, updated_at DESC")
    render "horses"
  end

  def staff
    @notes = Note.where(:category => Note::STAFF).order("urgent DESC, updated_at DESC")
  end

  def show_staff
    @staff = Staff.find(params[:staff_id])
    @notes = Note.where(:staff_id => params[:staff_id]).order("urgent DESC, updated_at DESC")
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

  private

  def load_subjects
    @bookings = Booking.all.sort{|a,b| a.event.name <=> b.event.name}
    @clients = Client.order("last_name")
    @horses = Horse.order("name")
    @staff = Staff.order("last_name")
  end

  def validation fields, id
    @errors = []
    @errors << "Note must have a title." unless fields[:title].length > 0
    @errors << "Note must have some content." unless fields[:content].length > 0
    @errors << "Note must have a category." if fields[:category] == "0"
    case fields[:category]
    when Note::BOOKING
      @errors << "Booking category must be linked to a booking." if fields[:booking_id] == "0"
    when Note::CLIENT
      p "HERE!"
      @errors << "Client category must be linked to a client." if fields[:client_id] == "0"
    when Note::HORSE
      @errors << "Horse category must be linked to a horse." if fields[:horse_id] == "0"
    when Note::STAFF
      @errors << "Staff category must be linked to staff." if fields[:staff_id] == "0"
    end
    @validated = @errors.length > 0 ? false : true
  end
end