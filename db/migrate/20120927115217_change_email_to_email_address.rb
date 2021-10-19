class ChangeEmailToEmailAddress < ActiveRecord::Migration[5.2]
  def up
    rename_column :clients, :email, :email_address
  end
end
