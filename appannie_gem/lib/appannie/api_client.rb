require 'dotenv'
require 'rest-client'
require 'json'
class ApiClient
  def initialize
    Dotenv.load

    @api_ver = 'v1.2'
    @api_key = ENV['APPANNIE_GLOBAL_APIKEY']
    @api_url = "https://api.appannie.com/#{@api_ver}/"
    @parser = Parser.new
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
    response = self.get(resource)
    JSON.parse(response)
  end

  def get_ios_rating(app_id)
    resource = "apps/ios/app/#{app_id}/ratings"
    response = self.get(resource)
    @parser.parse_rating(response, :ios)

  end

  def get_android_rating(app_id)
    resource = "apps/google-play/app/#{app_id}/ratings"
    response = self.get(resource)
    @parser.parse_rating(response, :android)
  end

  def get_ios_rankings(app_id, category)
    start_date = (Date.today - 60).strftime("%Y-%m-%d")
    end_date = (Date.today - 1).strftime("%Y-%m-%d")

    resource = "apps/ios/app/#{app_id}/ranks?start_date=#{start_date}&end_date=#{end_date}&interval=daily&countries=DE&category=#{category}&feed=free&device=iphone"
    response = self.get(resource)
    @parser.parse_rankings(response)
  end

  def get_android_rankings(app_id, category)
    start_date = (Date.today - 60).strftime("%Y-%m-%d")
    end_date = (Date.today - 1).strftime("%Y-%m-%d")


    resource = "apps/google-play/app/#{app_id}/ranks?start_date=#{start_date}&end_date=#{end_date}&interval=daily&countries=DE&category=#{category}&feed=free"
    response = self.get(resource)
    @parser.parse_rankings(response)
  end

  def get_ios_reviews(app_id)
    resource = "apps/ios/app/#{app_id}/reviews?countries=DE&page_index=0"
    response = self.get(resource)
    @parser.parse_reviews(response)
  end

  def get_ios_downloads(app_id)
    start_date = (Date.today - 30).strftime("%Y-%m-%d")
    end_date = (Date.today - 1).strftime("%Y-%m-%d")

    account_id = ENV['ACCOUNT_ID']
    country = "DE"
    resource = "accounts/#{account_id}/products/#{app_id}/sales?start_date=#{start_date}&end_date=#{end_date}&countries=#{country}&break_down=date"
    
    fullUrl = @api_url + resource
    headers = { Authorization: "bearer #{ENV['APPANNIE_IOS_APIKEY']}", Accept:'application/json' }
    response = RestClient.get(fullUrl, headers)

    @parser.parse_downloads(response)
  end

end