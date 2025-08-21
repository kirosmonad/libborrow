class Book < ApplicationRecord
  validates :title, :genre, :author, :isbn, presence: true
  validates :isbn, uniqueness: true
  validates :total_copies, numericality: { only_integer: true }
end
