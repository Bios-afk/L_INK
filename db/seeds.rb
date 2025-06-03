# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'

puts '🧹destroying all records...'
User.destroy_all
Artist.destroy_all
Client.destroy_all

puts '🚀creating Users, Artists and Clients...'
10.times do
  client = Client.create!()
  User.create!(
    email: Faker::Internet.email,
    password: "AZERTY",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    bio: Faker::Lorem.paragraph,
    userable: client,
  )

  artist = Artist.create!(address: 'bordeaux, france')
  User.create!(
    email: Faker::Internet.email,
    password: "AZERTY",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    bio: Faker::Lorem.paragraph,
    userable: artist,
  )
end

puts '✅seeding completed!'
