class AddExerciseToHorses < ActiveRecord::Migration[5.2]
  def change
    add_column :horses, :exercise, :boolean
  end
end
