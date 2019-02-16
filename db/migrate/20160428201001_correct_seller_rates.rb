class CorrectSellerRates < ActiveRecord::Migration[4.2]
  def up
    Seller.transaction do
      Seller.list.each do |seller|
        seller.correct_rate # make it explicit - also done by before_validation hook
        seller.save!
      end
    end
  end

  def down
  end
end
