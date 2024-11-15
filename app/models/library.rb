class Library < ApplicationRecord
  has_many :user,  dependent: :delete_all
  has_many :book,  dependent: :delete_all
  has_many :member,  dependent: :delete_all

  validates  :name, presence: true, uniqueness: true
end