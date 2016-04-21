class RemoveUniquenessFromTaskSortKey < ActiveRecord::Migration
  def change
    remove_index :tasks, :sort_key
    add_index :tasks, :sort_key
  end
end
