require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

module WarehouseCms
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    config.assets.enabled = true

    config.assets.version = '1.0'

    # FIXME: convert to standard ISO?
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.assets.paths << "#{Rails.root}/app/assets/fonts"

    config.assets.precompile += %w( login.css )
    config.assets.precompile += %w( landings.css )
    config.assets.precompile += %w( landings.js )

    config.skylight.environments += ['uat']
  end
end
