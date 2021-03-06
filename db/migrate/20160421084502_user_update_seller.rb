class UserUpdateSeller < ActiveRecord::Migration[4.2]
  def up
    User.transaction do
      User.all.each do |user|
        # runs the validation hooks and thereby sets the user's seller
        user.save! if user.seller?
      end
    end
  end
end
