WarehouseCms::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  apipie
  namespace :users do
    resources :locations
    resources :product_barcodes
    resources :tour_entries do
      collection { get :download }
      collection { put :adjust_variance }
      collection { put :reject_variance }
      collection { post :assign_tour }
      member { put :adjust_variance }
      member { put :reject_variance }
    end
    resources :stock_levels do
      collection { get :download }
      collection { get :sample }
      collection { get :import }
      collection { post :process_import }
      collection { post :assign_stock_levels }
    end

    resources :users, :except => :show
    get 'admins/:id/password_update' => 'admins#password_update', as: :password_update

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
      resources :entries, controller: 'tour_entries', 
                          action: 'scoped_by_tour', 
                          only: [:index], 
                          as: 'scoped_by_tour'
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
