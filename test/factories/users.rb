FactoryBot.define do
  factory :user do
    email_address { "sample@sample.com" }
    password { "password" }
    password_confirmation { "password" }

    trait :librarian do
      role { "librarian" }
    end
  end
end
