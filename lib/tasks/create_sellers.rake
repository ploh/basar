desc "Create sellers by drawing lots"
task create_sellers: [:environment, :verbose] do
  User.transaction do
    User.all.each do |user|
      if user.weighting < -90
        user.weighting = -50
      elsif user.weighting > 90
        user.weighting = 50
      end
      user.save!
    end
  end

  srand 456438111
  Seller.transaction do
    weighted_users = User.all.reject {|user| !user.seller? || user.seller}.map do |user|
      weighting = 2.0 ** user.weighting
      Rails.logger.info sprintf("Weighting for %-25s: %.2e", user.name, weighting)
      [user, weighting]
    end.to_h

    [:wish_a, :wish_b, :wish_c].each do |wish_sym|
      Rails.logger.info "Drawing sellers for #{wish_sym}..."

      pd = ProbabilityDistribution.new weighted_users
      while user = pd.draw
        wish = Seller.models_by_id[user.send wish_sym]

        if wish && Seller.available?(wish)
          seller = Seller.new(user: user, model: wish)
          seller.number = user.old_number || Seller.generate_number
          seller.initials = user.old_initials || user.initials
          seller.valid?
          unless seller.errors.empty?
            Rails.logger.warn "Could not save seller #{seller.inspect} because of errors: #{seller.errors.full_messages}"
            Rails.logger.info "Generating new number for #{seller.inspect}..."
            seller.number = Seller.generate_number
            seller.initials = user.initials
          end
          Rails.logger.info "Saving new seller #{seller.inspect}..."
          seller.save!
          weighted_users.delete user
        end
      end
    end

    if ENV["DRY_RUN"]
      raise "dry run"
    end
  end
end
