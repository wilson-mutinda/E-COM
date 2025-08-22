class Device < ApplicationRecord
  has_one :payment

  # attach image
  has_one_attached :image

  # validations
  validates :name, presence: true
  validates :brand, presence: true
  validates :model, presence: true
  validates :specs, presence: true
  validates :price, presence: true
  validates :discount, presence: true
  validates :image, presence: true
end
