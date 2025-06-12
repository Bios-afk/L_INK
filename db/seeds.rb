require 'faker'
require "open-uri"

def attach_gallery_photos(artist, urls)
  urls.each_with_index do |url, i|
    artist.photos.attach(
      io: URI.open(url),
      filename: "gallery_photo_#{i + 1}.jpg",
      content_type: "image/jpeg"
    )
  end
end

def attach_avatar(user, url)
  user.avatar.attach(
    io: URI.open(url),
    filename: File.basename(URI.parse(url).path),
    content_type: "image/jpeg"
  )
end

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
  "Traditionnel / Old School",
  "Néotraditionnel",
  "Japonais / Irezumi",
  "Réaliste",
  "Black & Grey",
  "Blackwork",
  "Dotwork / Pointillisme",
  "Géométrique",
  "Sketch / Trash Polka",
  "Fantasy",
  "Lettrage / Calligraphie",
  "Watercolor / Aquarelle",
  "Minimaliste / Fineline",
  "Ornemental / Mandala",
  "Tribal",
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

  artist = Artist.create!(
  address: address,
  rating: rand(1..5),
  ratings_count: rand(1..20) # ou 0 si tu veux parfois aucun avis
  )

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

felix = User.create!(
  email: 'felix.korbendau@free.fr',
  password: "Felix_33",
  pseudo: 'bios',
  first_name: 'Felix',
  last_name: 'Ix',
  bio: 'Modestemment le meilleur tatoueur de Bordeaux',
  userable: Artist.create!(
  address: '24 Rue Saint-Rémi, 33000 Bordeaux, France',
  rating: rand(1..5),
  ratings_count: rand(1..20)
)
)
felix.categories = Category.where(name: "Japonais / Irezumi")

tribal_jam = User.create!(
  email: 'tribal@free.fr',
  password: "tribal33",
  pseudo: 'Tribal_Jam',
  first_name: 'Tribal',
  last_name: 'Jam',
  bio: 'Une illusion s éfface, Remind me baby of you',
  userable: Artist.create!(
  address: '24 Rue neuve, 33000 Bordeaux, France',
  rating: rand(1..5),
  ratings_count: rand(1..20)
)
)
tribal_jam.categories = Category.where(name: "Tribal")

# URLs des images pour la galerie de Tribal Jam
tribal_jam_gallery_urls = [
  "https://res.cloudinary.com/dntveegeg/image/upload/v1749717263/tribal1_drwyfi.jpg",
  "https://res.cloudinary.com/dntveegeg/image/upload/v1749717263/tribal2_i0i8d8.jpg",
  "https://res.cloudinary.com/dntveegeg/image/upload/v1749717263/tribal3_h1bdsk.jpg",
  "https://res.cloudinary.com/dntveegeg/image/upload/v1749717264/tribal4_yc94js.jpg",
  "https://res.cloudinary.com/dntveegeg/image/upload/v1749717265/tribal5_ajtmxv.jpg",
  "https://res.cloudinary.com/dntveegeg/image/upload/v1749717265/tribal6_ookshp.jpg"
]

# Ajout des photos à la galerie
attach_gallery_photos(tribal_jam.userable, tribal_jam_gallery_urls)

# Avatar
attach_avatar(tribal_jam, "https://res.cloudinary.com/dntveegeg/image/upload/v1749717259/tribal_avatar_mlgcds.jpg")


jojo_fantaisie = User.create!(
  email: 'jojo@fantaisie.fr',
  password: 'jojo33',
  pseudo: 'Jojo_fantaisie',
  first_name: 'Jojo',
  last_name: 'Fantaisie',
  bio: 'Je me drogue à la vie',
  userable: Artist.create!(
  address: '54 Rue Sainte Catherine, 33000 Bordeaux, France',
  rating: rand(1..5),
  ratings_count: rand(1..20)
)
)
jojo_fantaisie.categories = Category.where(name: "Fantasy")

johnny = User.create!(
  email: 'johnny@gmail.fr',
  password: 'jojo33',
  pseudo: 'Johnny',
  first_name: 'Johnny',
  last_name: 'Holidays',
  bio: 'Il suffira d une étincelle 🔥',
  userable: Artist.create!(
  address: '2 place Paul Doumer, 33000 Bordeaux, France',
  rating: rand(1..5),
  ratings_count: rand(1..20)
)
)
johnny.categories = Category.where(name: "Réaliste")

mime = User.create!(
  email: 'mime@gmail.fr',
  password: 'mime33',
  pseudo: 'Mime',
  first_name: 'Mime',
  last_name: 'Mime',
  bio: '... 🫢',
  userable: Artist.create!(
  address: '2 place du palais, 33000 Bordeaux, France',
  rating: rand(1..5),
  ratings_count: rand(1..20)
)
)
mime.categories = Category.where(name: "Dotwork / Pointillisme")

yokai_hermit = User.create!(
  email: 'yokai@gmail.fr',
  password: 'yokai33',
  pseudo: 'Yokai_Hermit',
  first_name: 'Yokai',
  last_name: 'Hermit',
  bio: 'Kage Bushin no Justu 🦊',
  userable: Artist.create!(
  address: '10 place Gambetta, 33000 Bordeaux, France',
  rating: "5",
  ratings_count: rand(1..20)
)
)
yokai_hermit.categories = Category.where(name: "Black & Grey")

creepy_girl = User.create!(
  email: 'firegirl@gmail.fr',
  password: 'fire33',
  pseudo: 'CreepyGirl',
  first_name: 'Creepy',
  last_name: 'Girl',
  bio: 'Ce soir, on vous met le feu ! 🔥',
  userable: Artist.create!(
  address: '15 rue porte Dijeau, 33000 Bordeaux, France',
  rating: rand(1..5),
  ratings_count: rand(1..20)
)
)
creepy_girl.categories = Category.where(name: "Sketch / Trash Polka")





puts "✅ Création et association terminées !"

puts "📊 Récapitulatif :"
puts "   -> #{Client.count} clients"
puts "   -> #{Artist.count} artistes"
puts "   -> #{User.count} users"
puts "   -> #{Category.count} styles"
puts "   -> #{TattooCategory.count} attributions artiste-style"

puts "🌱 Seeds terminés avec succès !"
