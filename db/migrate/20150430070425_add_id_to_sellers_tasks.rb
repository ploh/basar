class AddIdToSellersTasks < ActiveRecord::Migration
  def change
    add_column :sellers_tasks, :id, :primary_key
  end
end
