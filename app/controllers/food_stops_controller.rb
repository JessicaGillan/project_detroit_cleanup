class FoodStopsController < ApplicationController
  def index
    @food_stops = FoodStopSearcher.search( { query:       params[:query],
                                             day_filter:  params[:days],
                                             time_filter: params[:times] } )
  end

  def show
  end
end
