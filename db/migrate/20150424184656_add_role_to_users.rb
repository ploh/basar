class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer

    User.all.each do |user|
      user.set_default_role
      user.save!
    end
  end
end
