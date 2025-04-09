FactoryBot.define do
  factory :survey do
    name { "Sample Survey" }
    description { "Survey description" }
    status { "active" }

    association :rating_scale
  end
end
