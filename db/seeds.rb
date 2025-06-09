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

big_french_cities = [
  "Paris", "Marseille", "Lyon", "Toulouse", "Nice", "Nantes",
  "Strasbourg", "Montpellier", "Bordeaux", "Lille"
]

bordeaux_addresses = [
  "10 Rue Sainte-Catherine, Bordeaux",
  "22 Cours Victor Hugo, Bordeaux",
  "5 Place de la Bourse, Bordeaux",
  "13 Rue Parlement Saint-Pierre, Bordeaux",
  "7 Quai des Chartrons, Bordeaux",
  "18 Rue du Pas-Saint-Georges, Bordeaux",
  "25 Rue Mably, Bordeaux",
  "3 Rue Saint-James, Bordeaux"
]

puts '🚀 Création des clients et artistes...'

10.times do |i|
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

  # Adresse de l'artiste
  if i < 8
    address = bordeaux_addresses[i]
  else
    city = big_french_cities.sample
    street = Faker::Address.street_address
    address = "#{street}, #{city}, France"
  end

  artist = Artist.create!(address: address)

  # Géocodage automatique avec Geocoder (attention à l'API limit)
  if artist.respond_to?(:geocode) && artist.address.present?
    artist.geocode
    artist.save!
  end

  user = User.create!(
    email: Faker::Internet.unique.email,
    password: "AZERTY",
    pseudo: Faker::Internet.unique.username(specifier: 5..10),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    bio: Faker::Lorem.paragraph,
    userable: artist
  )

  sample_styles = Category.order("RANDOM()").limit(rand(1..3))
  user.categories << sample_styles
end

User.create!(
  email: 'felix.korbendau@free.fr',
  password: "Felix_33",
  pseudo: 'bios',
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  bio: Faker::Lorem.paragraph,
  userable: Artist.create!(address: '24 Rue Saint-Rémi, 33000 Bordeaux, France')
)

puts "✅ Création et association terminées !"

puts "📊 Récapitulatif :"
puts "   -> #{Client.count} clients"
puts "   -> #{Artist.count} artistes"
puts "   -> #{User.count} users"
puts "   -> #{Category.count} styles"
puts "   -> #{TattooCategory.count} attributions artiste-style"

puts "🌱 Seeds terminés avec succès !"
