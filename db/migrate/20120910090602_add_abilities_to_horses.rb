class AddAbilitiesToHorses < ActiveRecord::Migration[5.2]
  def change
    add_column :horses, :walk, :boolean
    add_column :horses, :trot_with, :boolean
    add_column :horses, :trot_without, :boolean
    add_column :horses, :canter, :boolean
    add_column :horses, :hack, :boolean
    add_column :horses, :jump_5_meter, :boolean
    add_column :horses, :jump_75_meter, :boolean
    add_column :horses, :x_country, :boolean
  end
end
