class AccountController < ApplicationController
  skip_before_action :user_permission?

  def index
  end

  def change_password
    if params[:old] == User.decrypt(current_user.password)
      if params[:pass] == params[:confirm]
        current_user.change_password params[:pass]
        json = {:result => "Password was successfully changed"}
      else
        json = {:error => true, :result => "New password and confirmation don't match"}
      end
    else
      json = {:error => true, :result => "Incorrect password"}
    end
    render :json => json
  end
end
