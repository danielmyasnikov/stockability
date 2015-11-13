WarehouseCms::Application.routes.draw do

  apipie
  namespace :users do
    resources :locations
    resources :product_barcodes
    resources :tour_entries do
      collection { get :download }
    end
    resources :stock_levels do
      collection { get :download }
      collection { get :sample }
      collection { get :import }
      collection { post :process_import }
      collection { post :process_stock_levels }
    end
    resources :users, :except => :show
    resources :bins
    resources :companies
    resources :products do
      collection { get :download }
      collection { get :sample }
      collection { get :import }
      collection { post :process_import }
    end
    resources :tours do
      collection { get :download }
    end
  end

  devise_for :users, :controllers => {
    :registrations => 'stockability_auth/registrations',
    :sessions => 'stockability_auth/sessions',
    :passwords => 'stockability_auth/passwords'
  }

  authenticated :user do
    root :to => "application#index"
  end

  api_version(:module => "v1", :path => { :value => "api/v1" }, :defaults => {:format => "json"}) do
    resources :products
    resources :product_barcodes
    resources :stock_levels
    resources :tour_entries
    resources :tours
    resources :tokens, :only => :create
  end

  get '/' => 'landings#splash'
end
