class Category < ApplicationRecord
  has_many :users, through: :tattoo_categories

  validates :name, presence: true, uniqueness: true
end
