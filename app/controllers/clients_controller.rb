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
  end

  def edit
  end

  def show
  end

  def remove
  end

  def remove_info
  end

  def create
  end

  def update
  end

  def destroy
  end
end