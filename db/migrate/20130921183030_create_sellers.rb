class CreateSellers < ActiveRecord::Migration[4.2]
  def change
    create_table :sellers do |t|
      t.string :name
      t.integer :number
      t.string :initials
      t.decimal :rate

      t.timestamps
    end
  end
end
