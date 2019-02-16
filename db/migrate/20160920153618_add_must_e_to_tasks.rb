class AddMustEToTasks < ActiveRecord::Migration[4.2]
  def change
    add_column :tasks, :must_e, :boolean
  end
end
