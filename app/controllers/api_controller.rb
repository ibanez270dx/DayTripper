class ApiController < ActionController::API
  require 'yelp'

  def generate
    client = Yelp::Client.new({
      consumer_key: Rails.application.secrets.yelp_consumer_key,
      consumer_secret: Rails.application.secrets.yelp_consumer_secret,
      token: Rails.application.secrets.yelp_token,
      token_secret: Rails.application.secrets.yelp_token_secret})

    response = client.search("San Francisco", {term: "Kokkari Estiatorio", location: "200 Jackson St" })
    x = response.businesses
    # @business = response.business.name
    render json: x
  end
end