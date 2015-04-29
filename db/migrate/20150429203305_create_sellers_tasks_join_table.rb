class CreateSellersTasksJoinTable < ActiveRecord::Migration
  def change
    create_join_table :sellers, :tasks do |t|
      # t.index [:seller_id, :task_id]
      t.index [:task_id, :seller_id], unique: true
      t.index :task_id
      t.index :seller_id
    end
  end
end
