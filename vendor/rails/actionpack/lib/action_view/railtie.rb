require "action_view"
require "rails"

module ActionView
  class Railtie < Rails::Railtie
    plugin_name :action_view

    require "action_view/railties/subscriber"
    subscriber ActionView::Railties::Subscriber.new

    initializer "action_view.cache_asset_timestamps" do |app|
      unless app.config.cache_classes
        ActionView::Helpers::AssetTagHelper.cache_asset_timestamps = false
      end
    end
  end
end