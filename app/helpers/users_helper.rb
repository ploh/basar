module UsersHelper
  def available_users seller
    User.list.find_all do |user|
      (seller && user == seller.user) ||
      (user.seller? && !user.seller)
    end.sort_by {|user| user.last_name.downcase}
  end
end
