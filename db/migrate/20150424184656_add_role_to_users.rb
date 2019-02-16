class AddRoleToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :role, :integer

    User.all.each do |user|
      user.set_default_role
      user.save!
    end
  end
end
