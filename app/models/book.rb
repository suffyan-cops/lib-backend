class Book < ApplicationRecord
  has_many :request
  belongs_to :library
  validates  :title, presence: true, uniqueness: true

  scope :with_library_name, -> { joins(:library).select('books.*, libraries.name as library_name') }

  scope :by_user_library, ->(library_id) { where(library_id: library_id).joins(:library).select('books.*, libraries.name as library_name') }
end
