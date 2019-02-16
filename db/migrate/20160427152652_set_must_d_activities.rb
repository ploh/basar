class SetMustDActivities < ActiveRecord::Migration[4.2]
  def up
    Seller.transaction do
      Seller.list.each do |seller|
        seller.fill_activities
        seller.correct_must_d_activities
        seller.save!
      end
    end
  end

  def down
  end
end
