class AddRemarkToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :remark, :string
  end
end
