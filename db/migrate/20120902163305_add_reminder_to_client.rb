class AddReminderToClient < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :last_reminder, :date
  end
end
