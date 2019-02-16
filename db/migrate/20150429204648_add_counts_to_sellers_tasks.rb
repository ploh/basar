class AddCountsToSellersTasks < ActiveRecord::Migration[4.2]
  def change
    add_column :sellers_tasks, :planned_count, :integer
    add_column :sellers_tasks, :actual_count, :integer
  end
end
