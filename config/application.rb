require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module WarehouseCms
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    config.assets.enabled = true

    config.assets.version = '1.0'

    # FIXME: convert to standard ISO?
    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
  end
end
