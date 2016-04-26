desc "Make logger verbose and to stdout"
task verbose: :environment do
  logger = Logger.new STDOUT
  logger.level = Logger::DEBUG
  Rails.logger = logger
end

namespace :backup do
  desc "Load data.yml into dev db and reset passwords"
  task load: [:environment, :verbose] do
    Rake::Task["db:data:dump"].invoke
    User.transaction do
      User.all.each do |user|
        user.password = "asdfasdf"
        user.save!
        Rails.logger.info "Saved #{user.description}"
      end
    end
  end
end
