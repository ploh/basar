require File.expand_path('../boot', __FILE__)

require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Basar
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "Berlin"

    config.i18n.available_locales = [:en, :de]

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :de

    config.sass.preferred_syntax = :sass

    config.action_view.field_error_proc = Proc.new do |html_tag, instance|
      if html_tag.start_with?("<label")
        html_tag
      else
        error_message =
          instance.error_message.kind_of?(Array) ?
          instance.error_message.join(', ') :
          instance.error_message
        %(#{html_tag}<div class="validation_error">#{error_message}</div>).html_safe
      end
    end
  end
end

# monkey patch new connection creation to execute an arbitrary sql statement
# in the new connection, e.g. to set pragmas
module ActiveRecord
  module ConnectionAdapters
    class ConnectionPool
      alias :new_connection_orig :new_connection
      def new_connection *args
        connection = new_connection_orig *args
        if statements = spec.config[:statements]
          statements = [statements] unless statements.kind_of?(Enumerable)
          statements.each do |stmt|
            connection.raw_connection.execute stmt
          end
        end
        connection
      end
    end
  end
end
