class ChangeWeightFields < ActiveRecord::Migration
  def change
    change_column :horses, :max_weight, :integer
    change_column :clients, :weight, :integer
  end
end
