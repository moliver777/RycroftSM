class ClientsController < ApplicationController
  skip_before_filter :user_permission?, :only => [:index]

  def index
    @clients = Client.order("last_name")
  end

  def sort
    @clients = Client.order(params[:sort]+" "+params[:mod]+", last_name")
    view = render_to_string(:partial => "table_contents")
    render :json => view.to_json
  end

  def new
    @client = Client.new
  end

  def edit
    @client = Client.find(params[:client_id])
  end

  def create
    client = Client.new
    client.set_fields params[:fields]
    render :nothing => true
  end

  def update
    client = Client.find(params[:client_id])
    client.set_fields params[:fields]
    render :nothing => true
  end

  def destroy
    Client.find(params[:client_id]).destroy
    render :nothing => true
  end
end