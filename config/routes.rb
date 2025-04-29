Rails.application.routes.draw do
  devise_for :users
  
  root 'pages#home'
  
  get '/search', to: 'pages#search'
  
  resources :hotels do
    resources :rooms do
      resources :bookings, only: [:new, :create] do
        member do
          get 'confirmation'
        end
      end
      member do
        get 'availability'
      end
    end
  end
  
  resources :bookings, except: [:new, :create]
  
  # User dashboard
  get '/dashboard', to: 'users#dashboard'

  get "users/index"
  get "users/show"
  get "users/new"
  get "users/create"
  get "users/edit"
  get "users/update"
  get "users/destroy"
  get "bookings/index"
  get "bookings/show"
  get "bookings/new"
  get "bookings/create"
  get "bookings/edit"
  get "bookings/update"
  get "bookings/destroy"
  get "rooms/index"
  get "rooms/show"
  get "rooms/new"
  get "rooms/create"
  get "rooms/edit"
  get "rooms/update"
  get "rooms/destroy"
  get "hotels/index"
  get "hotels/show"
  get "hotels/new"
  get "hotels/create"
  get "hotels/edit"
  get "hotels/update"
  get "hotels/destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
