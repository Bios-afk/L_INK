class User < ApplicationRecord
  has_one_attached :avatar, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :userable, polymorphic: true
  has_many :tattoo_categories, dependent: :destroy
  has_many :categories, through: :tattoo_categories


  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :pseudo, presence: true, uniqueness: true

end
