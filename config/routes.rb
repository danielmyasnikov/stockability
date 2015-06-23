WarehouseCms::Application.routes.draw do

  namespace :admin do
    resources :tours
  end

  namespace :admin do
    resources :locations
    resources :product_barcodes
    resources :tour_entries
    resources :stock_levels
    resources :admins, :except => :show
    resources :bins
    resources :companies
    resources :products
    resources :tours, :only => [ :index, :show, :destroy ]
  end

  # think to change to member
  comfy_route :cms_admin, :path => '/admin'

  devise_for :admins

  api_version(:module => "v1", :path => { :value => "api/v1" }, :defaults => {:format => "json"}) do
    put  'products/update'
    post 'tours', :controller => 'tours', :action => 'create'
    resources :tokens, :only => :create
  end

  comfy_route :cms, :path => '/*', :sitemap => false

  get '/' => 'welcome#splash'

end
