WarehouseCms::Application.routes.draw do

  namespace :admin do
    resources :admins, :except => :show
    resources :bins
    resources :companies
    resources :products
    resources :sessions, :only => [:index, :show, :destroy], :as => :walkthrough_sessions
  end

  comfy_route :cms_admin, :path => '/admin'

  devise_for :admins

  api_version(:module => "v1", :path => {:value => "api/v1"}, :defaults => {:format => "json"}) do
    put  'products/update'
    post 'sessions', :controller => 'sessions', :action => 'create'
  end

  comfy_route :cms, :path => '/', :sitemap => false

end
