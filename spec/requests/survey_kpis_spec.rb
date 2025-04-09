# spec/requests/survey_kpis_controller_spec.rb
require 'rails_helper'

RSpec.describe "Survey KPIs", type: :request do
  let!(:survey) { create(:survey) }

  describe "GET /surveys/:survey_id/kpis/average_scores_per_category" do
    it "returns success" do
      get "/surveys/#{survey.id}/kpis/average_scores_per_category"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /surveys/:survey_id/kpis/completion_rate" do
    it "returns success" do
      get "/surveys/#{survey.id}/kpis/completion_rate"
      expect(response).to have_http_status(:success)
    end
  end

  # Add more tests for other KPI endpoints similarly
end
