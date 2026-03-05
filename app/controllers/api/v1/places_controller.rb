module Api
  module V1
    class PlacesController < ApplicationController

      def index
        # Prevent N+1 performance issues & Filtering by city_code index
        places = Place.includes(:markers, :comments)
        places = places.by_city(params[:city_code]) if params[:city_code].present?

        render json: PlaceBlueprint.render(places)
      end

      def show
        place = Place.includes(:markers, :comments).find(params[:id])
        
        if stale?(place)
          render json: PlaceBlueprint.render(place)
        end
      end
    end
  end
end