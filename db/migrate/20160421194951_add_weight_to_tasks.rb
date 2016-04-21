class AddWeightToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :weight, :float
  end
end
