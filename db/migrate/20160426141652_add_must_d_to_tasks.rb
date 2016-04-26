class AddMustDToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :must_d, :boolean
  end
end
