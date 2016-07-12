desc "Anonymize all user/seller data"
task anonymize: [:environment, :verbose] do
  User.transaction do
    User.all.each do |user|
      if user.seller?
        user.password = "asdfasdf"
        user.first_name = Faker::Name.first_name
        user.last_name = Faker::Name.last_name
        user.email = Faker::Internet.safe_email
        user.skip_confirmation!
        user.skip_reconfirmation!
        user.save!
        Rails.logger.info "Saved #{user.description}"
      end
    end
  end
end
