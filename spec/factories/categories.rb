FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "test_category_name_#{n}" }

    trait :invalid do
      name { '' }
    end
  end
end
