class AddPreferenceAndSiteSettingTables < ActiveRecord::Migration
  def change
    create_table :preferences, :force => true do |t|
      t.string :name
      t.text :value
      t.timestamps
    end

    create_table :site_settings, :force => true do |t|
      t.string :name
      t.text :value
      t.string :external
      t.timestamps
    end
  end
end

