class Question < ApplicationRecord
  belongs_to :category
  has_many :responses, dependent: :destroy
  has_many :survey_questions, dependent: :destroy
end
