class AddKindToTasks < ActiveRecord::Migration[4.2]
  def change
    add_column :tasks, :kind, :integer
  end
end
