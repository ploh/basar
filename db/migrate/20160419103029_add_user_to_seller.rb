class AddUserToSeller < ActiveRecord::Migration[4.2]
  def change
    add_reference :sellers, :user, index: true
  end
end
