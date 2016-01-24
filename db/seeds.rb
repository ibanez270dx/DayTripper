require 'csv'

categories = {
  businesses: Category.create(name: 'Businesses').id,
  park_and_open_space: Category.create(name: 'Parks and Open Spaces').id,
  bike_share: Category.create(name: 'Bike Share Locations').id,
  art_collection: Category.create(name: 'Art Collection').id
}

# Directory containing our acvtivity data
data = "#{Rails.root}/db/activity_data"

#################################################
# Import Registered Businesses
#################################################

start_businesses = Time.now
file = "#{data}/Registered_Business_Map.csv"
CSV.parse(File.read(file), headers: true).each do |row|
  unless \
    row['City'].try(:downcase) != "san francisco" ||
    row['Class Code'] != "07" ||
    row['Business_Location'].blank? ||
    row['DBA Name'] =~ /apartment/i

    address = row['Business_Location'].split("\n")
    Activity.create({
      name: row['DBA Name'].titleize,
      location: address.pop,
      address: address.collect(&:titleize).join(", "),
      category_id: categories[:businesses]
    })
  end
end
puts "Imported Registered Businesses in #{Time.now.to_f-start_businesses.to_f} seconds"

#################################################
# Import Parks and Open Spaces
#################################################

start_parks = Time.now
file = "#{data}/Park_and_Open_Space_Map.csv"
CSV.parse(File.read(file), headers: true).each do |row|
  if row["Location 1"]
    address = row["Location 1"].split("\n")
    Activity.create(
      category_id: categories[:park_and_open_space],
      name: row['ParkName'].titleize,
      location: address.pop,
      address: address.collect(&:titleize).join(", "),
      description: row['ParkType']
    )
  end
end
puts "Imported Parks and Open Spaces in #{Time.now.to_f-start_parks.to_f} seconds"

#################################################
# Import Bike Share Stations
#################################################

start_bikes = Time.now
file = "#{data}/BikeShareStationsPilot_092014.csv"
CSV.parse(File.read(file), headers: true).each do |row|
  Activity.create(
    category_id: categories[:bike_share],
    name: "#{row['Site_ID'].titleize}",
    location: "(#{row['long']}, #{row['Lat']})",
    description: "#{row['Location_N']}"
  )
end
puts "Imported Bike Share Stations in #{Time.now.to_f-start_bikes.to_f} seconds"

#################################################
# Import SF Civic Art Collection
#################################################

start_art = Time.now
file = "#{data}/SF_Civic_Art_Collection.csv"
CSV.parse(File.read(file), headers: true).each do |row|
  if \
    row['geometry'].present? &&
    row['title'].present? &&
    row['location_description'].present?

    geometry = row['geometry']
    Activity.create(
      category_id: categories[:art_collection],
      name: row['title'].titleize,
      address: row['location_description'].titleize,
      location: geometry['coordinates'],
      description: "#{row['artist']}\n#{row['credit_line']}"
    )
  end
end
puts "Imported SF Civic Art Collection in #{Time.now.to_f-start_art.to_f} seconds"
