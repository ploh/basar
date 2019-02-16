class AddTransactionToItem < ActiveRecord::Migration[4.2]
  def change
    add_reference :items, :transaction, index: true
  end
end
