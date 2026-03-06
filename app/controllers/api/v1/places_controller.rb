module Api
  module V1
    class PlacesController < ApplicationController

      def index
        # Prevent N+1 performance issues & Filtering by city_code index
        places = Place.includes(:markers, :comments)
        places = places.by_city(params[:city_code]) if params[:city_code].present?
        places = places.search_by_name(params[:name]) if params[:name].present?

        render json: PlaceBlueprint.render(places)
      end

      def show
        place = Place.includes(:markers, :comments).find(params[:id])

        if stale?(place)
          render json: PlaceBlueprint.render(place)
        end
      end

      def rate
        place = Place.find(params[:id])
        
        # Validate the rating
        score = params[:score].to_f
        if score >= 1 && score <= 5
          if place.add_rating(score)
            render json: { 
              message: "Rating updated successfully", 
              average_rating: place.average_rating, 
              ratings_count: place.ratings_count 
            }, status: :ok
          else
            render json: { error: "Could not update rating" }, status: :unprocessable_entity
          end
        else
          render json: { error: "Score must be between 1 and 5" }, status: :bad_request
        end
      end
    end
  end
end