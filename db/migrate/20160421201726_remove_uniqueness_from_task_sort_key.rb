class RemoveUniquenessFromTaskSortKey < ActiveRecord::Migration[4.2]
  def change
    remove_index :tasks, :sort_key
    add_index :tasks, :sort_key
  end
end
