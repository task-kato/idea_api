FactoryBot.define do
    factory :idea do
      sequence(:body) { |n| "test_idea_body_#{n}"}
      association :category

      trait :invalid do
        body {''}
      end
    end
end