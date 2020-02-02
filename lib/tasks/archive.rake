desc "Archive last bazaar data - deletes all transactions"
task archive: [:environment, :verbose] do
  Seller.transaction do
    Transaction.all.each do |transaction|
      transaction.destroy
    end
    Rails.logger.info 'Deleted all transactions!'

    Seller.all.each do |seller|
      if user = seller.user
        user.old_number = seller.number
        user.old_initials = seller.initials
        user.save!
        seller.destroy!
        Rails.logger.info "Deleted #{seller}!"
      else
        raise "No user for seller: #{seller}"
      end
    end

    User.all.each do |user|
      user.wish_a = nil
      user.wish_b = nil
      user.wish_c = nil
      user.cake = nil
      user.help = nil
      user.save!
      Rails.logger.info "Updated #{user}!"
    end

    if Setting[:drawn_applicants]
      Setting.destroy :drawn_applicants
      # Rails.logger.error "IMPORTANT!!! Now remove drawn_applicants flag!"
    end
  end
end
