class SellerMailer < ApplicationMailer
  def apply user
    @user = user
    @terms = true
    recipient = %("#{@user.name}" <#{@user.email}>)
    mail to: recipient, subject: "Verkäuferplatz beantragt"
  end

  def welcome seller
    @seller = seller
    @user = seller.user
    @terms = true
    raise unless @user
    recipient = %("#{@user.name}" <#{@user.email}>)
    attachments['Ichthys_Basar_2019_09_Flyer.pdf'] = File.read('public/info/Ichthys_Basar_2019_09_Flyer.pdf')
    mail to: recipient, subject: "Sie sind dabei, Verkäufer #{seller.code}"
  end

  def regret user
    @user = user
    recipient = %("#{@user.name}" <#{@user.email}>)
    mail to: recipient, subject: "Sie sind leider nicht dabei"
  end
end
