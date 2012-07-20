class AccountController < ApplicationController
  skip_before_filter :user_permission?

  def index
  end

  def edit
  end

  def update
  end
end