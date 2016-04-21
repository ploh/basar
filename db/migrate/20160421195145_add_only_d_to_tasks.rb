class AddOnlyDToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :only_d, :boolean
  end
end
