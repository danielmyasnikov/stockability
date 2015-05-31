task :update_tokens => :environment do
  Admin.all.map(&:save_with_token)
end
