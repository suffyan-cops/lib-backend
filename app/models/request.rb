class Request < ApplicationRecord
  enum status: {Submitted: 0, Completed: 1, Rejected: 2 }
  belongs_to :user
  belongs_to :book


  validates  :book_id, presence: true
  validates  :user_id, presence: true
end