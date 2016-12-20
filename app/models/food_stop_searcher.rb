class FoodStopSearcher

  DOMAIN = "data.sfgov.org"
  DATASET_ID = "bbb8-hzi6"

  def initialize
    @client = SODA::Client.new({:domain => DOMAIN, :app_token => Rails.application.secrets.soda_app_token})
  end

  def general( limit = 10 )
    @client.get(DATASET_ID, {"$limit" => 10})
  end

  def
end
