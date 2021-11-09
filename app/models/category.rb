class Category < ApplicationRecord
  has_many :ideas

  validates :name, uniqueness: true, presence: true
end
