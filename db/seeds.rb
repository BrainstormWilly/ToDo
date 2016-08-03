# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
5.times do
  user = User.create(name: Faker::Name.name, email: Faker::Internet.email, password: "123456", password_confirmation: "123456")
end
users = User.all

me = User.create(name: "Willy", email: "brainstormwilly@gmail.com", password: "123456", password_confirmation: '123456')

rand(5..10).times do
  list = List.create(title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, user: users.sample)
end
lists = List.all

rand(50..80).times do
  item = Item.create( title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph, list: lists.sample )
end
