class AddFirstNameAndLastNameToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :first_name, :string, null: false, default: ""
    add_column :users, :last_name, :string, null: false, default: ""

    User.all.each do |user|
      user.first_name = user.name
      user.last_name = user.name
      user.save
    end
  end
end
