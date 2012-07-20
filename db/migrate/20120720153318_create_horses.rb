class CreateHorses < ActiveRecord::Migration
  def change
    create_table :horses, :force => true do |t|
      t.string :name
      t.string :standard
      t.integer :max_day_workload
      t.boolean :availability
      t.boolean :farrier
      t.date :farrier_date
      t.integer :farrier_freq
      t.boolean :worming
      t.date :worming_date
      t.string :worming_freq
      t.boolean :vet
      t.date :vet_date
      t.string :vet_freq
      t.boolean :medication
      t.date :medication_date
      t.string :medication_freq
      t.timestamps
    end
  end
end