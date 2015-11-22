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

  factory :signup do
    sequence(:email) { |n| "arun#{n}@example.com" }
    password "password"
  end

  factory :person do
    name "FirstName LastName"
    email
    hired_on { Date.current }
    account
  end
end
