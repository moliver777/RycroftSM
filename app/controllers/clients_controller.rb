class ClientsController < ApplicationController
  skip_before_filter :user_permission?, :only => [:index,:show]

  def index
    @clients = Client.where(hidden: false).order("first_name, last_name")
  end

  def horses
    @client = Client.where(hidden: false).find(params[:client_id])
    @mapping = @client.horses ? @client.horses.split(";") : []
    @horses = Horse.where(hidden: false).order("name")
  end

  def set_horses
    client = Client.find(params[:client_id])
    client.set_horses params[:fields]
    render :nothing => true
  end

  def no_horses
    @clients = []
    Client.where(hidden: false).order(:first_name).each do |client|
      if !client.leasing
        if client.horses
          @clients << client if client.horses.split(";").length==0
        else
          @clients << client
        end
      end
    end
  end

  def sort
    @clients = Client.where(hidden: false).order(params[:sort]+" "+params[:mod]+", first_name, last_name")
    view = render_to_string(:partial => "table_contents")
    render :json => view.to_json
  end

  def new
    @client = Client.new
  end

  def show
    @client = Client.find(params[:client_id])
  end

  def edit
    @client = Client.find(params[:client_id])
  end

  def create
    validation params[:fields], 0
    if @validated
      client = Client.new
      client.set_fields params[:fields]
    end
    render :json => @errors.to_json
  end

  def update
    validation params[:fields], params[:client_id]
    if @validated
      client = Client.find(params[:client_id])
      client.set_fields params[:fields]
    end
    render :json => @errors.to_json
  end

  def destroy
    client = Client.find(params[:client_id])
    client.notes.destroy_all
    client.update_attribute(:hidden, true)
    # client.destroy
    render :nothing => true
  end

  private

  def validation fields, id
    @errors = []
    @errors << "Client must have a first name." unless fields[:first_name].length > 0
    @errors << "Client must have a last name." unless fields[:last_name].length > 0
    if fields[:day] != "0" && fields[:month] != "0" && fields[:year] != "0"
      begin
        Date.parse(fields[:year]+"-"+fields[:month]+"-"+fields[:day])
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