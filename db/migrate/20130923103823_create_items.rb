class CreateItems < ActiveRecord::Migration[4.2]
  def change
    create_table :items do |t|
      t.references :seller, index: true
      t.decimal :price, precision: 6, scale: 2

      t.timestamps
    end
  end
end
