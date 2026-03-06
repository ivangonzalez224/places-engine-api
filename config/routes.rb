Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :places, only: [:index, :show] do
      		member do
        		post 'rate' # /api/v1/places/:id/rate
      		end
    		end
    end
  end
end