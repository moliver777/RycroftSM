class ChangeEmailToEmailAddress < ActiveRecord::Migration
  def up
    rename_column :clients, :email, :email_address
  end
end
