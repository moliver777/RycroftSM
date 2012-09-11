class AddFieldsToHorses < ActiveRecord::Migration
  def change
    add_column :horses, :feed, :string
    add_column :horses, :feed_extras, :string
    add_column :horses, :hay_weight, :float, :default => 0.00
    add_column :horses, :description, :text
    add_column :horses, :height, :string
    add_column :horses, :colour, :string
    add_column :horses, :max_weight, :integer
    add_column :horses, :owner, :string
    add_column :horses, :owner_email, :string
    add_column :horses, :heart_check, :string
    add_column :horses, :eyes_check, :string
    add_column :horses, :trot_up_check, :string
    add_column :horses, :tack_check_bridle, :string
    add_column :horses, :tack_check_saddle, :string
    add_column :horses, :tack_check_notes, :text
    add_column :horses, :physio_frequency, :string
    add_column :horses, :temp, :string
    add_column :horses, :pulse, :string
    add_column :horses, :respiration, :string
    add_column :horses, :turnout_group, :integer, :default => 0
  end
end
