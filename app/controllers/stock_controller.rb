class StockController < ApplicationController
  before_filter :master_only, :except => :index

  def index
    @items = Stock.order(:quantity, :name)
  end

  def new
    @item = Stock.new
  end

  def edit
    @item = Stock.find(params[:stock_id])
  end

  def create
    validation params[:fields]
    if @validated
      item = Stock.new
      item.set_fields params[:fields]
    end
    render :json => @errors.to_json
  end

  def update
    validation params[:fields]
    if @validated
      item = Stock.find(params[:stock_id])
      item.set_fields params[:fields]
    end
    render :json => @errors.to_json
  end

  def destroy
    item = Stock.find(params[:stock_id])
    item.destroy
    render :nothing => true
  end

  def quantity
    item = Stock.find(params[:stock_id])
    count = item.update_quantity params[:direction]
    render :json => {:stock_id => item.id, :count => count}
  end

  private

  def validation fields
    @errors = []
    @errors << "Item must have a name." unless fields[:name].length > 0
    @validated = @errors.length > 0 ? false : true
  end

  def master_only
    if current_user
      if current_user.user_level != User::MASTER
        redirect_to "/"
      end
    end
  end
end