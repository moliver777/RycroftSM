class AddExerciseToHorses < ActiveRecord::Migration
  def change
    add_column :horses, :exercise, :boolean
  end
end
