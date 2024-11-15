class Book < ApplicationRecord
  has_many :request
  belongs_to :library
  validates  :title, presence: true, uniqueness: true
end
