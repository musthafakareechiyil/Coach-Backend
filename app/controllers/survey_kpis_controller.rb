class SurveyKpisController < ApplicationController
  before_action :set_survey

  def average_scores_per_category
    survey = Survey.find(params[:survey_id])
    questions = survey.questions.includes(:category, :responses)

    # Calculate max score from rating scale
    max_score = survey.rating_scale.rating_options.maximum(:value).to_f
    return render json: { error: "No rating scale values found." }, status: :unprocessable_entity if max_score.zero?

    categories_data = {}

    questions.each do |question|
      category = question.category
      next unless category

      categories_data[category.id] ||= {
        category_id: category.id,
        category_name: category.name,
        total_score: 0,
        response_count: 0
      }

      question.responses.each do |response|
        score = response.rating_option&.value || 0
        categories_data[category.id][:total_score] += score
        categories_data[category.id][:response_count] += 1
      end
    end

    result = categories_data.values.map do |cat|
      avg_score = cat[:response_count] > 0 ? cat[:total_score].to_f / cat[:response_count] : 0
      percent = (avg_score / max_score) * 100
      classification = case percent
      when 0..30 then "Poor"
      when 30...61 then "Average"
      when 61...81 then "Good"
      else "Very Proficient"
      end

      {
        category_id: cat[:category_id],
        category_name: cat[:category_name],
        average_score: avg_score.round(2),
        percentage: percent.round(2),
        classification: classification
      }
    end

    render json: result
  end

  def completion_rate
    total_users = @survey.users.count
    completed = @survey.responses.select(:user_id).distinct.count

    rate = total_users > 0 ? ((completed.to_f / total_users) * 100).round(2) : 0

    render json: {
      total_users: total_users,
      completed_users: completed,
      completion_rate: rate
    }
  end

  def engagement_index
    survey = Survey.find(params[:survey_id])

    total_score = survey.responses.joins(:rating_option).sum("rating_options.value")
    max_score = survey.responses.count * survey.rating_scale.rating_options.maximum(:value).to_f

    engagement = max_score > 0 ? ((total_score.to_f / max_score) * 100).round(2) : 0

    render json: {
      engagement_index: engagement
    }
  end

  def performance_brackets
    user_scores = {}

    @survey.responses.includes(:rating_option).each do |r|
      user_scores[r.user_id] ||= 0
      user_scores[r.user_id] += r.rating_option.value
    end

    total_questions = @survey.questions.count
    max_score_per_user = total_questions * 5

    brackets = {
      poor: 0,
      average: 0,
      good: 0,
      very_proficient: 0
    }

    user_scores.each_value do |score|
      percent = (score.to_f / max_score_per_user) * 100
      case percent
      when 0..30 then brackets[:poor] += 1
      when 31..60 then brackets[:average] += 1
      when 61..80 then brackets[:good] += 1
      else brackets[:very_proficient] += 1
      end
    end

    total_users = @survey.users.count

    render json: brackets.transform_values { |count|
      {
        count: count,
        percentage: total_users > 0 ? ((count.to_f / total_users) * 100).round(2) : 0
      }
    }
  end

  private

  def set_survey
    @survey = Survey.find_by(id: params[:survey_id])
    render json: { error: "Survey not found" }, status: :not_found unless @survey
  end
end
