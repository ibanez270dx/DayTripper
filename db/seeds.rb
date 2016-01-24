require 'csv'

categories = {
  film_locations: Category.create(name: 'Film Locations').id,
  park_and_open_space: Category.create(name: 'Park and Open Space').id,
  bike_share: Category.create(name: 'Bike Share Locations').id,
  art_collection: Category.create(name: 'Art Collection').id
}

data = "#{Rails.root}/db/activity_data"
file = "#{data}/Park_and_Open_Space_Map.csv"
csv = CSV.parse(File.read(file), headers: true).each do |row|
  address = row['Location 1'].split("\n")
  Activity.create(
    category_id: categories[:park_and_open_space],
    name: "#{row['ParkName']}",
    address: "#{address[0]}",
    location: "#{address[-1]}",
    description: "#{row['ParkType']}"
    )
end

data = "#{Rails.root}/db/activity_data"
file = "#{data}/BikeShareStationPilot_092014.csv"
csv = CSV.parse(File.read(file), headers: true).each do |row|
  Activity.create(
    category_id: categories[:bike_share],
    name: "#{row['Site_ID']}",
    location: "#{row['long']} #{row['Lat']}",
    description: "#{row['Location_N']}"
  )
end

data = "#{Rails.root}/db/activity_data"
file = "#{data}/SF_Civic_Art_Collection.csv"
csv = CSV.parse(File.read(file), headers: true).each do |row|
  address = (JSON.parse(row['geometry']))['coordinates']
  Activity.create(
    category_id: categories[:art_collection],
    name: "#{row['title']}",
    address: "#{row['location_description']}"
    location: "#{address}",
    description: "#{row['source']}"
  )
end