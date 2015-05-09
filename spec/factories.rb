FactoryGirl.define do

  factory :admin do
    sequence(:email) { |i| FFaker::Internet.email.sub('@', "#{i}@") }
    password    { FFaker::Internet.password(8) }

    trait :super do
      role :super
    end

    trait :member do
      role :member
    end
  end
end
