class CreateTransactions < ActiveRecord::Migration[4.2]
  def change
    create_table :transactions do |t|

      t.timestamps
    end
  end
end
