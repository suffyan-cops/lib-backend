class Book < ApplicationRecord
  has_many :request
  belongs_to :library
  validates  :title, presence: true, uniqueness: true

  scope :with_library_name, -> { joins(:library).select('books.*, libraries.name as library_name') }

  scope :by_user_library, ->(library_id) { where(library_id: library_id).joins(:library).select('books.*, libraries.name as library_name') }

  scope :available_book_count_for_admin, -> { left_joins(:request).where('requests.status IS NULL OR requests.status != 1').distinct.count}

  scope :get_book_against_user_id, -> (library_id) {joins(:library).where(library_id: library_id).where('CAST(books.quantity AS INTEGER) > ?', 0).select('books.*, libraries.name as library_name')}

  scope :search_for_admin, -> (query) {joins(:library).where("books.title ILIKE? ", "%#{query}%").select('books.*, libraries.name as library_name')}

end
