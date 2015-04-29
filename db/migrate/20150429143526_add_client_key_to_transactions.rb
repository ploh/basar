class AddClientKeyToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :client_key, :string
  end
end
