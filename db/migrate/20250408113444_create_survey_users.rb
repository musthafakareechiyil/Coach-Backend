class CreateSurveyUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :survey_users do |t|
      t.references :survey, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
