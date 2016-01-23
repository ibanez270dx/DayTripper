class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :neighborhood_id
      t.integer :category_id
      t.string :name
      t.string :address
      t.string :location
      t.text :description
      t.decimal :rating
      t.timestamps null: false
    end
  end
end
