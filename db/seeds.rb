# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.create(email_address: "sample@sample.com", password: "password", password_confirmation: "password")
librarian = User.create(email_address: "lib@sample.com", password: "password", password_confirmation: "password", role: "librarian")

Book.create(title: "Sample Book Title", author: "Sample Author", isbn: "123-4567890123", genre: "Fiction", total_copies: 5)
Book.create(title: "Another Sample Book", author: "Another Author", isbn: "123-4567890124", genre: "Non-Fiction", total_copies: 3)
