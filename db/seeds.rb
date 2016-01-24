require 'csv'

categories = {
  businesses: Category.create(name: 'Business').id
  restaurants: Category.create(name: 'Restaurants').id
}

# Directory containing our acvtivity data
data = "#{Rails.root}/db/activity_data"

# Registered Businesses
file = "#{data}/Registered_Business_Map.csv"
start_businesses = Time.now
CSV.parse(File.read(file), headers: true).each do |row|
  unless \
    row['City'].try(:downcase) != "san francisco" ||
    row['Class Code'] != "07" ||
    row['Business_Location'].blank? ||
    row['DBA Name'] =~ /apartment/i

    address = row['Business_Location'].split("\n")
    location = address.pop
    address = address.collect(&:titleize).join(", ")
    
    Activity.create({
      name: row['DBA Name'].titleize,
      location: address.pop,
      address: address.collect(&:titleize).join(", "),
      category_id: categories[:businesses]
    })
  end
end
puts "Imported Registered Businesses in #{Time.now.to_i-start_businesses.to_i} seconds"
