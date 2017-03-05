# Preview all emails at http://localhost:3000/rails/mailers/seller_mailer
class SellerMailerPreview < ActionMailer::Preview
  def apply
    wishful_users = User.seller.where.not(wish_a: nil)
    user = wishful_users.find {|u| !u.seller}
    p user
    SellerMailer.apply user
  end

  def welcome
    SellerMailer.welcome Seller.first
  end

  def regret
    wishful_users = User.seller.where.not(wish_a: nil)
    user = wishful_users.find {|u| !u.seller}
    p user
    SellerMailer.regret user
  end
end
