WarehouseCms::Application.routes.draw do

  apipie

  namespace :admin do
    resources :locations
    resources :product_barcodes
    resources :tour_entries
    resources :stock_levels do
      collection { get :download }
      collection { get :sample }
      collection { get :import }
      collection { post :process_import }
      collection { post :process_stock_levels }
    end
    resources :admins, :except => :show
    resources :bins
    resources :companies
    resources :products do
      collection { get :download }
      collection { get :sample }
      collection { get :import }
      collection { post :process_import }
    end
    resources :tours
  end

  # think to change to member
  comfy_route :cms_admin, :path => '/admin'

  devise_for :admins

  api_version(:module => "v1", :path => { :value => "api/v1" }, :defaults => {:format => "json"}) do
    resources :products
    resources :product_barcodes
    resources :stock_levels
    resources :tour_entries
    resources :tours
    resources :tokens, :only => :create
  end

  comfy_route :cms, :path => '/*', :sitemap => false

  get '/' => 'welcome#splash'
end
