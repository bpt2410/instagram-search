class Media

  def initialize(access_token)
    @access_token = access_token
  end

  def search(lat, lng, options = {})
    results = []
    client = Instagram.client(access_token: @access_token)
    if lat.present? && lng.present?
      begin
        results = client.media_search(lat, lng, options)
      rescue Exception => e
      end
    end

    # Sort by distance(closest first)
    results.sort! { |item_x, item_y|
      distance([lat.to_f, lng.to_f], [item_x.location.latitude, item_x.location.longitude]) <=> distance([lat.to_f, lng.to_f], [item_y.location.latitude, item_y.location.longitude])
    }

    results
  end

  def distance(loc1, loc2)
    Geocoder::Calculations.distance_between(loc1, loc2)
  end

  def location_by_coordinates(lat, lng)
    if (results = Geocoder.search([lat, lng])).size() > 0
      {
        location: "#{results.first.state}, #{results.first.country}",
        address: results.first.address
      }
    end
  end

  def self.authentication?
    result = false
    begin
      redis = Redis.new
      if access_token = redis.get('access_token')
        client = Instagram.client(access_token: access_token)
        if user = client.user
          result = true
        end
      end
    rescue
      result = false
    end
    result
  end

  def self.access_token
    redis = Redis.new
    redis.get('access_token')
  end

  def self.save_access_token(access_token)
    redis = Redis.new
    redis.set('access_token', access_token)
  end
end