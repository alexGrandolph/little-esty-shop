class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :percent
  validates_presence_of :threshold
end