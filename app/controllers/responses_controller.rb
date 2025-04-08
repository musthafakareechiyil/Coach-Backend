class ResponsesController < ApplicationController
  def index
    survey = Survey.find_by(id: params[:survey_id])
    return render json: { error: "Survey not found" }, status: :not_found unless survey

    responses = Response
      .where(survey_id: survey.id)
      .includes(:user, :rating_option, question: :category)

    result = responses.map do |response|
      {
        user: {
          id: response.user.id,
          name: response.user.name,
          email: response.user.email
        },
        question: {
          id: response.question.id,
          content: response.question.content,
          category: {
            id: response.question.category.id,
            name: response.question.category.name
          }
        },
        rating_option: {
          id: response.rating_option.id,
          label: response.rating_option.label,
          value: response.rating_option.value
        },
        created_at: response.created_at
      }
    end

    render json: { responses: result }, status: :ok
  end

  def create
    survey = Survey.find_by(id: params[:survey_id])
    user = User.find_by(id: params[:user_id])

    return render json: { error: "Invalid survey or user" }, status: :unprocessable_entity unless survey && user
    return render json: { error: "User not in survey" }, status: :unprocessable_entity unless survey.users.exists?(user.id)

    responses = []

    begin
      Response.transaction do
        params[:responses].each do |res|
          question = survey.questions.find_by(id: res[:question_id])
          rating_option = RatingOption.find_by(id: res[:rating_option_id])

          unless question && rating_option
            raise ActiveRecord::RecordInvalid.new(Response.new), "Invalid question or rating_option"
          end

          unless rating_option.rating_scale_id == survey.rating_scale_id
            raise ActiveRecord::RecordInvalid.new(Response.new), "Rating option mismatch with survey's rating scale"
          end

          responses << {
            survey_id: survey.id,
            user_id: user.id,
            question_id: question.id,
            rating_option_id: rating_option.id,
            created_at: Time.current,
            updated_at: Time.current
          }
        end

        Response.insert_all!(responses)
      end

      render json: { message: "Responses saved successfully." }, status: :created

    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Response save error: #{e.message}"
      render json: { error: "Response saving failed: #{e.message}" }, status: :unprocessable_entity
    rescue => e
      Rails.logger.error "Unexpected error: #{e.message}"
      render json: { error: "Unexpected error: #{e.message}" }, status: :internal_server_error
    end
  end
end
