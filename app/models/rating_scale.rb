class RatingScale < ApplicationRecord
  has_many :rating_options, dependent: :destroy
  has_many :surveys, dependent: :destroy
  has_many :responses, dependent: :destroy
end
