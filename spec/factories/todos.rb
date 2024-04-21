# frozen_string_literal: true

FactoryBot.define do
  factory :todo do
    title { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    status { [0, 1].sample }
  end

  trait :with_user do
    user_id { create(:user).id }
  end
end
