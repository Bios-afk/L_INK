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

puts '🧹 Destroying all records...'
Message.destroy_all
MessageFeed.destroy_all
Booking.destroy_all
User.destroy_all
Artist.destroy_all
Client.destroy_all

puts '🚀 Creating Users, Artists and Clients...'

10.times do
  # Création du client et de son user
  client = Client.create!
  User.create!(
    email: Faker::Internet.unique.email,
    password: "AZERTY",
    pseudo: Faker::Internet.unique.username(specifier: 5..10),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    bio: Faker::Lorem.paragraph,
    userable: client
  )

  # Création de l'artiste et de son user
  artist = Artist.create!(
    address: Faker::Address.city + ", " + Faker::Address.country
  )
  User.create!(
    email: Faker::Internet.unique.email,
    password: "AZERTY",
    pseudo: Faker::Internet.unique.username(specifier: 5..10),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    bio: Faker::Lorem.paragraph,
    userable: artist
  )

end

puts '✅ Seeding completed!'
