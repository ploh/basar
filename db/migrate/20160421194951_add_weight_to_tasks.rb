class AddWeightToTasks < ActiveRecord::Migration[4.2]
  def change
    add_column :tasks, :weight, :float
  end
end
