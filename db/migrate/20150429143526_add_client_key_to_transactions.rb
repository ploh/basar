class AddClientKeyToTransactions < ActiveRecord::Migration[4.2]
  def change
    add_column :transactions, :client_key, :string
  end
end
