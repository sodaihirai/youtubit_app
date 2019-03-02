require '/Users/hiraisodai/Projects/youtubit_app/lib/content_data/content_loader.rb'

module ContentData
  class Railtie < ::Rails::Railtie
    config.before_configuration { ::ContentLoader.load! }
    # devleopment環境の場合はrequest毎にリロード
    if ::Rails.env.development?
      initializer :content_data_reload_on_development do
        ActionController::Base.class_eval do
          if ::Rails::VERSION::MAJOR >= 4
            prepend_before_action { ::ContentLoader.reload! }
          else
            prepend_before_filter { ::ContentLoader.reload! }
          end
        end
      end
    end
  end
end
