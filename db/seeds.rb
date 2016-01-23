require 'csv'

categories = {
  film_locations: Category.create(name: 'Film Locations').id
}

# Directory containing our acvtivity data
data = "#{Rails.root}/db/activity_data/"

# Film Locations
file = "#{data}/Film_Locations_in_San_Francisco.csv"
CSV.parse(File.read(file), headers: true).each do |row|
  Activity.create(
    category_id: categories[:film_locations],
    name: "#{row['Title']} (#{row['Release Year']})",
    description: "
      Location: #{row['Locations']}\n
      Fun Facts: #{row['Fun Facts']}\n
      Production Company: #{row['Production Company']}\n
      Distributor: #{row['Distributor']}\n
      Director: #{row['Director']}\n
      Writer: #{row['Writer']}\n
      Actors: #{row['Actor 1']} #{row['Actor 2']} #{row['Actor 3']}
    "
end


# <CSV::Row "Title":"180" "Release Year":"2011" "Locations":"City Hall" "Fun Facts":nil "Production Company":"SPI Cinemas" "Distributor":nil "Director":"Jayendra" "Writer":"Umarji Anuradha, Jayendra, Aarthi Sriram, & Suba " "Actor 1":"Siddarth" "Actor 2":"Nithya Menon" "Actor 3":"Priya Anand" "Smile Again, Jenny Lee":nil>
