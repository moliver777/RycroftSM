class AddFieldsToClients < ActiveRecord::Migration
  def change
    add_column :clients, :height, :string
    add_column :clients, :weight, :string
    add_column :clients, :injury, :boolean
    add_column :clients, :injury_details, :text
    add_column :clients, :medical_notes, :text
    add_column :clients, :tetanus_date, :date
    add_column :clients, :doctor, :string
    add_column :clients, :doctor_contact, :string
    add_column :clients, :times_ridden, :string
    add_column :clients, :walk, :boolean
    add_column :clients, :trot_with, :boolean
    add_column :clients, :trot_without, :boolean
    add_column :clients, :canter, :boolean
    add_column :clients, :hack, :boolean
    add_column :clients, :jump_5_meter, :boolean
    add_column :clients, :jump_75_meter, :boolean
    add_column :clients, :x_country, :boolean
    add_column :clients, :heard_about_us, :string
  end
end
