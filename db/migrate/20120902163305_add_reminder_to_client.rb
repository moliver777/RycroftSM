class AddReminderToClient < ActiveRecord::Migration
  def change
    add_column :clients, :last_reminder, :date
  end
end
