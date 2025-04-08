class User < ApplicationRecord
  has_many :survey_users
  has_many :surveys, through: :survey_users
  has_many :responses, dependent: :destroy
end
