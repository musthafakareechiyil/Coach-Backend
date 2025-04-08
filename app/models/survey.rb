class Survey < ApplicationRecord
  belongs_to :rating_scale

  has_many :survey_questions, dependent: :destroy
  has_many :questions, through: :survey_questions, dependent: :destroy

  has_many :survey_users, dependent: :destroy
  has_many :users, through: :survey_users, dependent: :destroy
  has_many :responses, dependent: :destroy
end
