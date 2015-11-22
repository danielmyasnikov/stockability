namespace :super_admin do
  task :move => :environment do
    User.where(role: 'super_admin').each do |user|
      User.transaction do
        AdminUser.create! do |sa|
          sa.email = user.email
          sa.login = user.login
          sa.password = 'myNewPassword1234'
          sa.password_confirmation = 'myNewPassword1234'
        end
        user.destroy
      end
    end
  end
end