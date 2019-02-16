class AddIdToSellersTasks < ActiveRecord::Migration[4.2]
  def change
    add_column :sellers_tasks, :id, :primary_key
  end
end
