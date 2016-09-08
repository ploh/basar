class SetSellerModelFromUser < ActiveRecord::Migration
  def up
    Seller.transaction do
      Seller.all.each do |seller|
        user = seller.user
        if user
          seller.model = user.seller_model
          seller.save!
        end
      end
    end
  end
end
