class AddUserToSeller < ActiveRecord::Migration
  def change
    add_reference :sellers, :user, index: true, foreign_key: true
  end
end
