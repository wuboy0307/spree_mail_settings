module SpreeMailSettings
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_mail_settings'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer "spree_mail_settings" do |app|
      ActionMailer::Base.add_delivery_method :spree, Spree::Core::MailMethod
      if ActiveRecord::Base.connection.table_exists? 'spree_stores'
        Spree::Core::MailSettings.init
        Mail.register_interceptor(Spree::Core::MailInterceptor)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
