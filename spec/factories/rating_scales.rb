FactoryBot.define do
  factory :rating_scale do
    name { "5 Point Rating Scale" }
    description { "1 to 5 satisfaction range" }

    after(:create) do |scale|
      scale.rating_options.create!([
        { label: "Not At All", value: 1 },
        { label: "Slightly", value: 2 },
        { label: "Somewhat", value: 3 },
        { label: "Mostly", value: 4 },
        { label: "Completely", value: 5 }
      ])
    end
  end
end
