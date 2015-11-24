FactoryGirl.define do

  factory :user do

    password              'password'
    password_confirmation 'password'

    trait :company_admin do
      sequence(:login) { |i| FFaker::Internet.user_name }
      sequence(:email) { |i| FFaker::Internet.email.sub('@', "#{i}@") }
      role :admin
      company
    end

    trait :warehouse_manager do
      role :warehouse_manager
      sequence(:login) { |i| FFaker::Internet.user_name }
      sequence(:email) { |i| FFaker::Internet.email.sub('@', "#{i}@") }
      company
    end

    trait :warehouse_operator do
      role :warehouse_operator
      sequence(:login) { |i| FFaker::Internet.user_name }
      company
    end
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

  factory :tour do
    name { FFaker::Name.first_name.downcase }
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

end
