class FoodStopsController < ApplicationController
  def index
    @food_stops = FoodStopSearcher.new.general
  end

  def show
  end
end
