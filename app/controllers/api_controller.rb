class ApiController < ActionController::API
  require 'yelp'

  def generate
    client = Yelp::Client.new({
      consumer_key: Rails.application.secrets.yelp_consumer_key,
      consumer_secret: Rails.application.secrets.yelp_consumer_secret,
      token: Rails.application.secrets.yelp_token,
      token_secret: Rails.application.secrets.yelp_token_secret})

    p client.search("San Francisco")
  end
end