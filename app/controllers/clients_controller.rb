class ClientsController < ApplicationController
  skip_before_filter :user_permission?, :only => [:index]

  def index
    @clients = Client.order("last_name")
  end

  def sort
    @clients = Client.order(params[:sort]+", last_name")
    view = render_to_string(:partial => "table_contents")
    render :json => view.to_json
  end

  def new
    @client = Client.new
  end

  def edit
    @client = Client.find(params[:client_id])
  end

  def remove
  end

  def create
  end

  def update
  end

  def destroy
  end
end