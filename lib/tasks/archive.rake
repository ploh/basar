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
  end
end
