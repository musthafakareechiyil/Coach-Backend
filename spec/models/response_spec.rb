# spec/models/response_spec.rb
require 'rails_helper'

RSpec.describe Response, type: :model do
  it { should belong_to(:survey) }
  it { should belong_to(:user) }
  it { should belong_to(:question) }
  it { should belong_to(:rating_option) }
end
