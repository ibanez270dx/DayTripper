require 'csv'

class CreateNeighborhoods < ActiveRecord::Migration
  def up
    create_table :neighborhoods do |t|
      t.string :name
      t.timestamps null: false
    end

    Neighborhood.reset_column_information
    CSV.parse(File.read("#{Rails.root}/db/neighborhoods.csv")).each do |row|
      Neighborhood.create(name: row[0])
    end
  end

  def down
    drop_table :neighborhoods
  end
end
