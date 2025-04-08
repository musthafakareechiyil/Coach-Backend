class Response < ApplicationRecord
  belongs_to :survey
  belongs_to :user
  belongs_to :question
  belongs_to :rating_option
end
