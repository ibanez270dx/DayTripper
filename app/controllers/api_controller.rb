class ApiController < ActionController::API
  require 'yelp'

  def generate
    client = Yelp::Client.new({
      consumer_key: Rails.application.secrets.yelp_consumer_key,
      consumer_secret: Rails.application.secrets.yelp_consumer_secret,
      token: Rails.application.secrets.yelp_token,
      token_secret: Rails.application.secrets.yelp_token_secret})

    response = client.search("San Francisco", {term: params[:business_name], location: params[:address] })
    @business = response.businesses[0]

    render json: {rating_img_url: @business.rating_img_url,
                  rating_img_url_small:
                  @business.rating_img_url_small,
                  image_url: @business.image_url,
                  snippet_image_url: @business.snippet_image_url}
  end
end