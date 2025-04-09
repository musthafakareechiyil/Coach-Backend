class SurveysController < ApplicationController
  before_action :set_survey, only: [ :show, :update, :destroy ]

  def index
    surveys = Survey.includes(:rating_scale, :questions, :users)

    if params[:search].present?
      surveys = surveys.where("surveys.name ILIKE ?", "%#{params[:search]}%")
    end

    sort_by = params[:sort_by].presence_in(%w[name description created_at updated_at]) || "created_at"
    order = params[:order].to_s.downcase == "asc" ? :asc : :desc
    surveys = surveys.order(sort_by => order)

    render json: surveys.as_json(include: {
      rating_scale: { only: [ :id, :name ] },
      questions: { only: [ :id, :content ] },
      users: { only: [ :id, :name, :email ] }
    }, except: [ :created_at, :updated_at ])
  end

  def show
    render json: @survey.as_json(include: {
      rating_scale: { only: [ :id, :name ] },
      questions: { only: [ :id, :content ] },
      users: { only: [ :id, :name, :email ] }
    }, except: [ :created_at, :updated_at ])
  end

  def create
    survey = Survey.new(survey_params)

    if survey.save
      render json: survey, status: :created
    else
      render json: { errors: survey.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def update
    if @survey.update(survey_params)
      render json: @survey
    else
      render json: { errors: @survey.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @survey.destroy
    head :no_content
  end

  private

  def set_survey
    @survey = Survey.find(params[:id])
  rescue
    render json: { error: "Survey not found" }, status: :not_found
  end

  def survey_params
    params.require(:survey).permit(
      :name,
      :description,
      :status,
      :rating_scale_id,
      question_ids: [],
      user_ids: []
    )
  end
end
