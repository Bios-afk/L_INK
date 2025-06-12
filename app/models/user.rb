class User < ApplicationRecord
  has_one_attached :avatar, dependent: :destroy

  has_one_attached :ar_photo, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  belongs_to :userable, polymorphic: true

  has_many :tattoo_categories, dependent: :destroy
  has_many :categories, through: :tattoo_categories
  has_many :follows, dependent: :destroy
  has_many :followed_artists, through: :follows, source: :artist
  has_many :bookings, through: :userable, source: :bookings

  # messages
  has_many :messages, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :pseudo, presence: true, uniqueness: true
  validates :bio, length: { maximum: 100 }

  # geocoded_by :address
  # after_validation :geocode, if: :will_save_change_to_address?

  # application avatar par defaut
  def avatar_or_default
    if avatar.attached?
      avatar
    else
      # URL vers une image par défaut dans le dossier assets ou hébergée
      "default_avatar.png"
    end
  end
end
