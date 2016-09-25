class AddMustEToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :must_e, :boolean
  end
end
