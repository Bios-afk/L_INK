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

puts '🧹 Suppression des données existantes...'
Message.destroy_all
MessageFeed.destroy_all
Booking.destroy_all
User.destroy_all
Artist.destroy_all
Client.destroy_all
Category.destroy_all

puts '📦 Insertion des styles de tatouage...'

styles = [
  "Old School",
  "Néotraditionnel",
  "Traditionnel japonais Irezumi",
  "Blackwork",
  "Tribal",
  "Réalisme",
  "Surréalisme",
  "Illustratif",
  "Watercolor",
  "Sketch Esquisse",
  "Dotwork",
  "Géométrique",
  "Minimaliste Fine line",
  "Ignorant style",
  "Trash Polka",
  "Lettrage Calligraphie",
  "Chicano",
  "Ornemental Mandala",
  "Biomécanique Cyber",
  "Gothique Occulte"
]

styles.each do |style|
  Category.find_or_create_by!(name: style)
end

puts "✅ #{Category.count} styles insérés avec succès !"

puts '🚀 Création des clients et artistes...'

10.times do
  # Création d'un client et de son user
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

  # Création d'un artiste et de son user
  artist = Artist.create!(
    address: "#{Faker::Address.city}, #{Faker::Address.country}"
  )
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: "AZERTY",
    pseudo: Faker::Internet.unique.username(specifier: 5..10),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    bio: Faker::Lorem.paragraph,
    userable: artist
  )

  # Association de 1 à 3 styles aléatoires
  sample_styles = Category.order("RANDOM()").limit(rand(1..3))
  user.categories << sample_styles
end

puts "✅ Création et association terminées !"

puts "📊 Récapitulatif :"
puts "   -> #{Client.count} clients"
puts "   -> #{Artist.count} artistes"
puts "   -> #{User.count} users"
puts "   -> #{Category.count} styles"
puts "   -> #{TattooCategory.count} attributions artiste-style"

puts "🌱 Seeds terminés avec succès !"
