Basar::Application.configure do
  config.action_mailer.delivery_method = :sendmail

  config.action_mailer.default_options = { from: "info@kids-basar.de" }
end
