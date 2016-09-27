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
    remaining_users = User.all.reject {|user| !user.seller? || user.seller}

    [:wish_a, :wish_b, :wish_c].each do |wish_sym|
      Rails.logger.info "Drawing sellers for #{wish_sym}..."

      weighted_users =
        remaining_users.map do |user|
          wish = Seller.models_by_id[user.send wish_sym]
          [user, wish]
        end.find_all do |user, wish|
          wish
        end.map do |user, wish|
          weighting = 2.0 ** (user.weighting + Seller::MODEL_WEIGHTS[wish])
          Rails.logger.info sprintf("Weighting for %-25s, wish %s: %.2e", user.name, wish, weighting)
          [[user, wish], weighting]
        end


      pd = ProbabilityDistribution.new weighted_users
      while pair = pd.draw
        user, wish = *pair
        if Seller.available?(wish)
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
          remaining_users.delete user
        end
      end
    end

    Seller.group(:model).count.each do |model_id, count|
      Rails.logger.info sprintf "Sellers for model %s: %3d", Seller.models_by_id[model_id], count
    end

    if ENV["DRY_RUN"]
      raise "dry run"
    end
  end
end
