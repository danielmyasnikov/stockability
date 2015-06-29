WarehouseCms::Application.routes.draw do

  apipie

  namespace :admin do
    resources :locations
    resources :product_barcodes
    resources :tour_entries
    resources :stock_levels
    resources :admins, :except => :show
    resources :bins
    resources :companies
    resources :products
    resources :tours do
      collection { post :import }
    end
  end

  # think to change to member
  comfy_route :cms_admin, :path => '/admin'

  devise_for :admins

  api_version(:module => "v1", :path => { :value => "api/v1" }, :defaults => {:format => "json"}) do
    resources :products
    resources :tours
    resources :tokens, :only => :create
  end

  comfy_route :cms, :path => '/*', :sitemap => false

  get '/' => 'welcome#splash'

end
