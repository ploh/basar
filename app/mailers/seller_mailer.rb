class SellerMailer < ApplicationMailer
  def welcome seller
    @seller = seller
    @user = seller.user
    @terms = true
    raise unless @user
    recipient = %("#{@user.name}" <#{@user.email}>)
    mail to: recipient, subject: "Sie sind dabei, Verkäufer #{seller.code}"
  end

  def regret user
    @user = user
    recipient = %("#{@user.name}" <#{@user.email}>)
    mail to: recipient, subject: "Sie sind leider nicht dabei"
  end
end
