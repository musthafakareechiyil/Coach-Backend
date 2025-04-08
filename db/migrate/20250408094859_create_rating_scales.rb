class CreateRatingScales < ActiveRecord::Migration[8.0]
  def change
    create_table :rating_scales do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
