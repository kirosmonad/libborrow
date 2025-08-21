class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  enum :role, {
    user: 0,
    librarian: 1
  }
end
