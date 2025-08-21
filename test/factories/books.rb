FactoryBot.define do
  factory :book do
    title { |n| "Sample Book Title #{n}" }
    author { |n| "Sample Author #{n}" }
    isbn { |n| "123-456789012#{n}" }
    genre { |n| "Fiction #{n}" }
    total_copies { 5 }
  end
end
