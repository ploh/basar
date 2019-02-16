class AddMustDToTasks < ActiveRecord::Migration[4.2]
  def change
    add_column :tasks, :must_d, :boolean
  end
end
