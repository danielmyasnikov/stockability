FactoryGirl.define do

  factory :admin do

    trait :super_admin do
      sequence(:email) { |i| FFaker::Internet.email.sub('@', "#{i}@") }
      role :super_admin
    end

    password              'password'
    password_confirmation 'password'

    trait :member do
      login FFaker::Internet.user_name
      role :member
      company
    end

  end

  factory :company do
    title { FFaker::Name.first_name }
  end

  factory :site, :class => 'Comfy::Cms::Site' do
    identifier { FFaker::Name.first_name.downcase }
    label { FFaker::Name.first_name.downcase }
    hostname { 'localhost' }
  end

  factory :layout, :class => 'Comfy::Cms::Layout' do
    label { FFaker::Name.first_name }
    site
    identifier { FFaker::Name.first_name.downcase }
  end
end
