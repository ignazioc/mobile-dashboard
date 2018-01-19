class ApiClient
  def initialize
    @api_ver = 'v1.2'
    @api_key = ENV['APPANNIE_APIKEY']
    @api_url = "https://api.appannie.com/#{@api_ver}/"
  end

  def headers()
    { Authorization: "bearer #{@api_key}", Accept:'application/json' }
  end

  def get(url)
    begin
      fullUrl = @api_url + url
      RestClient.get(fullUrl, headers)

    rescue RestClient::Exception => e
      puts "=" * 50
      puts e.message
      puts "Request method: #{caller[1]}"
      puts "Request path:  /#{fullUrl}"
      puts "=" * 50
      nil
    end
  end

  def get_accounts
    resource = "accounts"
    return self.get(resource)
  end

  def get_ios_ratings(app_id)
    resource = "apps/ios/app/#{app_id}/ratings"
    return self.get(resource)
  end

  def get_google_ratings(app_id)
    resource = "apps/google-play/app/#{app_id}/ratings"
    return self.get(resource)
  end

  def get_ios_rankings(app_id, category)
    start_date = (Date.today - 1).strftime("%Y-%m-%d")
    end_date = (Date.today - 1).strftime("%Y-%m-%d")

    resource = "apps/ios/app/#{app_id}/ranks?start_date=#{start_date}&end_date=#{end_date}&interval=daily&countries=DE&category=#{category}&feed=free&device=iphone"
    return self.get(resource)
  end

  def get_android_rankings(app_id, category)
    start_date = (Date.today - 1).strftime("%Y-%m-%d")
    end_date = (Date.today - 1).strftime("%Y-%m-%d")


    resource = "apps/google-play/app/#{app_id}/ranks?start_date=2018-01-18&end_date=2018-01-18&interval=daily&countries=DE&category=#{category}&feed=free"
    return self.get(resource)
  end

  def get_ios_reviews(app_id)
    resource = "apps/ios/app/#{app_id}/reviews?countries=DE&page_index=0"
    return self.get(resource)
  end

end