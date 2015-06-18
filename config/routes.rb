WarehouseCms::Application.routes.draw do

  namespace :admin do
    resources :locations
  end

  namespace :admin do
    resources :admins, :except => :show
    resources :bins
    resources :companies
    resources :products
    resources :tours, :only => [ :index, :show, :destroy ]
  end

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
