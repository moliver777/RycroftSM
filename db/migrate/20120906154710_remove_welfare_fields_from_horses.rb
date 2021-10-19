class RemoveWelfareFieldsFromHorses < ActiveRecord::Migration[5.2]
  def change
    remove_column :horses, :farrier
    remove_column :horses, :farrier_date
    remove_column :horses, :farrier_freq
    remove_column :horses, :worming
    remove_column :horses, :worming_date
    remove_column :horses, :worming_freq
    remove_column :horses, :vet
    remove_column :horses, :vet_date
    remove_column :horses, :vet_freq
    remove_column :horses, :medication
    remove_column :horses, :medication_date
    remove_column :horses, :medication_freq
  end
end
