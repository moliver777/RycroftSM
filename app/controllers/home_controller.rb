class HomeController < ApplicationController
  skip_before_filter :user_permission?

  def index
  end

  def search
    results = []
    parse_search(params[:search]).split(" ").each do |term|
      Client.where("first_name LIKE ? OR last_name LIKE ?", term, term).each{|result| results << result}
    end
    @results = results.compact.uniq.sort{|a,b| a.last_name <=> b.last_name}
  end

  def schedule
  end

  def schedule_date
  end

  def event
  end

  private

  def parse_search search
    @search = ""
    search.split("").each do |char|
      @search += char if char.match(/\w|\s|\"|\'|\-/)
    end
    @search
  end
end
