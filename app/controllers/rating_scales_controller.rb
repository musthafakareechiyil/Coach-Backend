class RatingScalesController < ApplicationController
  before_action :set_rating_scale, only: [ :show, :update, :destroy ]

  def index
    rating_scales = RatingScale.includes(:rating_options).all
    render json: rating_scales.as_json(
      include: {
        rating_options: {
          except: [ :created_at, :updated_at ]
        }
      }
    )
  end

  def show
    render json: @rating_scale.as_json(include: {
      rating_options: {
        except: [ :created_at, :updated_at ]
      }
    })
  end

  def create
    rating_scale = RatingScale.new(rating_scale_params)

    if rating_scale.save
      render json: rating_scale.as_json(include: :rating_options), status: :created
    else
      render json: { errors: rating_scale.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @rating_scale.update(rating_scale_params)
      @rating_scale.rating_options.destroy_all if params[:rating_scale][:rating_options]
      @rating_scale.rating_options.create(params[:rating_scale][:rating_options]) if params[:rating_scale][:rating_options]

      render json: @rating_scale.as_json(include: :rating_options)
    else
      render json: { errors: @rating_scale.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @rating_scale.destroy
    head :no_content
  end

  private

  def set_rating_scale
    @rating_scale = RatingScale.includes(:rating_options).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Rating scale not found" }, status: :not_found
  end

  def rating_scale_params
    params.require(:rating_scale).permit(:name, :description, rating_options_attributes: [ :label, :value, :id ])
  end
end
