class SiteController < ApplicationController

  def index
    @neighborhoods = Neighborhood.select do |neighborhood|
      neighborhood.activities.count > 0
    end
  end

  def itinerary
    @neighborhood = Neighborhood.find(params[:neighborhood_id])
    @activities = @neighborhood.activities

    route = @activities.sample(4)
    route = route.collect { |x| x.location.strip.gsub(/\(|\)|\s/,'') }
    @url_path = route.join('/')+"/#{route.first}"
  end
end
