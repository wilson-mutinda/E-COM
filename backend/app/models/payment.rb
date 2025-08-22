class Payment < ApplicationRecord
  belongs_to :device
  belongs_to :customer
end
