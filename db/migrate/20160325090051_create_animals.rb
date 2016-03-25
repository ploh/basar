class CreateAnimals < ActiveRecord::Migration
  def change
    create_table :animals do |t|
      t.string :email
      t.integer :role

      t.timestamps null: false
    end
  end
end
