namespace :activities do

  desc "Get neighborhood for given address"
  task :get_neighborhoods => :environment do
    Activity.find_in_batches.with_index do |activities, batch|
      puts "Processing batch ##{batch}"
      activities.each do |activity|
        unless activity.neighborhood_id || activity.address.nil?
          address = activity.address.gsub(',','').gsub(' ','+')
          url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&#{Rails.application.secrets.google_geocoder}"
          response = Net::HTTP.get(URI(url))
          if response
            results = JSON.parse(response)
            results["results"][0]["address_components"].each do |address_component|
              if address_component["types"].include?("neighborhood")
                neighborhood = Neighborhood.find_by_name(address_component["long_name"])
                if neighborhood
                  activity.update_attributes neighborhood_id: neighborhood.id
                  puts "updated activity #{activity.id} with neighborhood #{neighborhood.id}"
                end
              end
            end
          end
        end
      end
    end
  end
end
