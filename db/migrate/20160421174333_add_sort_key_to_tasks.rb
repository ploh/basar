class AddSortKeyToTasks < ActiveRecord::Migration[4.2]
  def change
    add_column :tasks, :sort_key, :float
    add_index :tasks, :sort_key, unique: true
  end
end
