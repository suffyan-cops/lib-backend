class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  enum role: {super_admin: 0, librarian: 1, reader: 2 }
  validates  :name, presence: true, uniqueness: true
  validates  :email, presence: true, uniqueness: true
  validates :password, :presence => true, :confirmation => true, :length => {:within => 8..40}, :on => :create

  belongs_to :library, optional: true

  has_many :request

  has_many :book, through: :request

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

end