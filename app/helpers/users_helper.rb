module UsersHelper
  def available_users seller
    User.list.find_all do |user|
      (seller && user == seller.user) ||
      (user.seller? && !user.seller)
    end
  end
end
