class TattooCategory < ApplicationRecord
  belongs_to :user
  belongs_to :category
end
