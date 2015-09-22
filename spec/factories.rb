FactoryGirl.define do

  factory :admin do
    trait :super_admin do
      sequence(:email) { |i| FFaker::Internet.email.sub('@', "#{i}@") }
      role :super_admin
    end

    trait :company_admin do
      sequence(:login) { |i| FFaker::Internet.user_name }
      role :admin
      company
    end

    password              'password'
    password_confirmation 'password'
  end

  factory :company do
    title { FFaker::Name.first_name }
  end

  factory :location do
    sequence(:code) { |i| FFaker::Internet.user_name }
  end

  factory :product do
    sku 'ABC123'
    company
  end

  factory :product_barcode do
    barcode 'ZYX987'
    quantity 1
  end

  factory :stock_level do
    bin_code 'A07'
    batch_code 'ZYC334'
    quantity 1
    company
    location
    product
  end

  factory :site, :class => 'Comfy::Cms::Site' do
    identifier { FFaker::Name.first_name.downcase }
    label { FFaker::Name.first_name.downcase }
    hostname { 'localhost' }
  end

  factory :tour do

  end

  factory :tour_entry do
    tour
    location_code 'BATCH001'
    bin_code 'A08'
    sku 'BLA333'
    barcode 'BAR555'
    batch_code 'ZYX444'
    quantity 1
    active true
    company
  end

  factory :layout, :class => 'Comfy::Cms::Layout' do
    label { FFaker::Name.first_name }
    site
    identifier { FFaker::Name.first_name.downcase }
  end
end
