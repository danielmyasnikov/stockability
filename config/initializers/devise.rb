Devise.setup do |config|
  
  config.mailer_sender = 'support@stockability.com.au'

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [ :email ]

  config.strip_whitespace_keys = [ :email ]

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 10

  config.reconfirmable = true

  config.expire_all_remember_me_on_sign_out = true

  config.password_length = 8..128

  config.reset_password_within = 6.hours

  config.sign_out_via = :delete

  config.secret_key = '71486c9a237f880d5436ad734908f9b0f078fe6356f82c3e653738fabbadb167952ee31eba7a4d59214a0380aaee894734244f537cf2a85afbd737d6b4c47b79'

end
