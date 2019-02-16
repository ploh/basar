class AddUserToTransactions < ActiveRecord::Migration[4.2]
  def change
    add_reference :transactions, :user, index: true
  end
end
