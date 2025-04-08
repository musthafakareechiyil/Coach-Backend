class Question < ApplicationRecord
  belongs_to :category
  has_many :responses, dependent: :destroy
end
