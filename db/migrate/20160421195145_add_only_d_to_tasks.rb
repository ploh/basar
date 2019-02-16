class AddOnlyDToTasks < ActiveRecord::Migration[4.2]
  def change
    add_column :tasks, :only_d, :boolean
  end
end
