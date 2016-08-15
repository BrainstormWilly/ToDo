FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    sequence(:email){|n| "user#{n}@todo.com" }
    password "123456"
    password_confirmation "123456"
  end
end
