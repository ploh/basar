class AddUserToSeller < ActiveRecord::Migration[4.2]
  def change
    add_reference :sellers, :user, index: true, foreign_key: true
  end
end
