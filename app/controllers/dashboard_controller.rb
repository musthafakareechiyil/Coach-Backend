class DashboardController < ApplicationController
  def survey_status_count
    render json: {
      active: Survey.where(status: "active").count,
      completed: Survey.where(status: "completed").count,
      deactivated: Survey.where(status: "deactivated").count
    }
  end

  def user_count
    render json: { total_users: User.count }
  end

  def survey_growth
    interval = params[:interval] || "weekly"
    grouped_data =
      case interval
      when "daily" then Survey.group_by_day(:created_at).count
      when "weekly" then Survey.group_by_week(:created_at).count
      when "monthly" then Survey.group_by_month(:created_at).count
      when "yearly" then Survey.group_by_year(:created_at).count
      else Survey.group_by_week(:created_at).count
      end

    render json: grouped_data
  end

  def completion_summary
    data = Survey.all.map do |survey|
      total = survey.users.count
      completed = survey.responses.select(:user_id).distinct.count
      {
        survey_id: survey.id,
        survey_name: survey.name,
        total_users: total,
        completed_users: completed,
        completion_rate: total > 0 ? ((completed.to_f / total) * 100).round(2) : 0
      }
    end

    render json: data
  end

  def recent_activities
    recent_events = []

    # 1. New surveys created
    Survey.order(created_at: :desc).limit(5).each do |survey|
      recent_events << {
        message: "New survey '#{survey.name}' created",
        time: survey.created_at
      }
    end

    # 2. Recent user responses
    Response.order(created_at: :desc).limit(5).each do |response|
      user = User.find_by(id: response.user_id)
      survey = Survey.find_by(id: response.survey_id)

      if user && survey
        recent_events << {
          message: "#{user.name} submitted feedback for '#{survey.name}'",
          time: response.created_at
        }
      end
    end

    # 3. Survey completions (optional logic: when all assigned users have responded)
    Survey.all.each do |survey|
      total_users = survey.users.count
      completed_users = Response.where(survey_id: survey.id).select(:user_id).distinct.count

      if total_users > 0 && completed_users == total_users
        recent_events << {
          message: "Survey '#{survey.name}' completed by 100% users 🎉",
          time: survey.updated_at
        }
      end
    end

    # Sort all events by time, descending
    recent_events = recent_events.sort_by { |e| e[:time] }.reverse.first(10)

    render json: recent_events
  end

  def data_count
    render json: {
      total_questions: Question.count,
      total_categories: Category.count,
      total_responses: Response.count
    }
  end
end
