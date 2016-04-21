class AddLimitToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :limit, :integer
  end
end
