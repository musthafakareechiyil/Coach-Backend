class CreateRatingOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :rating_options do |t|
      t.string :label
      t.integer :value
      t.references :rating_scale, null: false, foreign_key: true

      t.timestamps
    end
  end
end
