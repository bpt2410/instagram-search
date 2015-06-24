class Media

  attr_accessor :access_token

  def initialize(access_token)
    @access_token = access_token
  end

  def search(lat, lng, options = {})
    results = nil
    client = Instagram.client(access_token: @access_token)
    if lat.present? && lng.present?
      begin
        results = client.media_search(lat, lng, options)
      rescue Exception => e
        results = nil
      end
    end

    # Sort by distance(closest first)
    if results.present?
      results.sort! { |item_x, item_y|
        distance([lat.to_f, lng.to_f], [item_x.location.latitude, item_x.location.longitude]) <=> distance([lat.to_f, lng.to_f], [item_y.location.latitude, item_y.location.longitude])
      }
    end

    results
  end

  def distance(loc1, loc2)
    begin
      dis = Geocoder::Calculations.distance_between(loc1, loc2)
      dis.to_s == 'NaN' ? 999999 : dis
    rescue
      999999
    end
  end

  def self.authentication?
    result = false
    begin
      if token = self.access_token
        client = Instagram.client(access_token: token)
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
    Rails.cache.read('access_token')
  end

  def self.set_access_token(access_token)
    Rails.cache.write('access_token', access_token)
  end
end