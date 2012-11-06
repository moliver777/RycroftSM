class ChangeSettingsFields < ActiveRecord::Migration
  def change
    remove_column :site_settings, :external
  end
end
