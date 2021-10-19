class ChangeSettingsFields < ActiveRecord::Migration[5.2]
  def change
    remove_column :site_settings, :external
  end
end
