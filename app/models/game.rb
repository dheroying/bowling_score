class Game < ApplicationRecord
  has_many  :shots, validate: true, dependent: :destroy
  validates :players, numericality: { greater_than: 0, less_than: 5 }
  accepts_nested_attributes_for :shots
end
