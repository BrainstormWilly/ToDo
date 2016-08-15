FactoryGirl.define do
  factory :list do
    title Faker::Lorem.sentence
    description Faker::Lorem.paragraph
    user nil
  end
end
