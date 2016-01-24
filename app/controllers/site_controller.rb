class SiteController < ApplicationController

  def index
    @neighborhoods = Neighborhood.select do |neighborhood|
      neighborhood.activities.count > 0
    end
  end

  def itinerary
    neighborhood = Neighborhood.find(params[:neighborhood_id])
    @activities = neighborhood.activities
  end
end
