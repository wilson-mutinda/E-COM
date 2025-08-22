class Customer < ApplicationRecord
  belongs_to :user
  has_many :devices

  has_many :payments

  # validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true
end
