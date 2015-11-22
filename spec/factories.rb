FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password "password"
  end

  factory :account do
    name "My Personal Account"
  end

  factory :membership do
    user
    account
  end
end
