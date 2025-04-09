# spec/requests/dashboard_controller_spec.rb
require 'rails_helper'

RSpec.describe "Dashboard", type: :request do
  describe "GET /dashboard/survey_status_count" do
    it "returns success" do
      get "/dashboard/survey_status_count"
      expect(response).to have_http_status(:success)
    end
  end
end
