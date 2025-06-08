class User < ApplicationRecord
  has_one_attached :avatar, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  belongs_to :userable, polymorphic: true

  has_many :tattoo_categories, dependent: :destroy
  has_many :categories, through: :tattoo_categories

  # messages
  has_many :messages, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :pseudo, presence: true, uniqueness: true

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
