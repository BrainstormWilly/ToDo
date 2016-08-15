FactoryGirl.define do
  factory :item do
    title Faker::Lorem.sentence
    body Faker::Lorem.paragraph
    list nil
  end
end
