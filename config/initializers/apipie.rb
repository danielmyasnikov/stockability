Apipie.configure do |config|
  config.reload_controllers      = Rails.env.development?
  config.app_name                = "StockAbility"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apipie"
  config.authenticate = Proc.new do
    authenticate_or_request_with_http_basic do |username, password|
      username == "stockability" && password == "8157secret"
    end
  end
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end
