class AddLimitToTasks < ActiveRecord::Migration[4.2]
  def change
    add_column :tasks, :limit, :integer
  end
end
