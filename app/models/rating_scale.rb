class RatingScale < ApplicationRecord
  has_many :rating_options, dependent: :destroy
  has_many :surveys, dependent: :destroy

  accepts_nested_attributes_for :rating_options, allow_destroy: true
end
