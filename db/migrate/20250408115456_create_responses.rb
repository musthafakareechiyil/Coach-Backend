class CreateResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :responses do |t|
      t.references :survey, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :rating_option, null: false, foreign_key: true

      t.timestamps
    end
  end
end
