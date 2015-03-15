WarehouseCms::Application.routes.draw do

  comfy_route :cms_admin, :path => '/admin'

  devise_for :admins

  api_version(:module => "v1", :path => {:value => "api/v1"}, :defaults => {:format => "json"}) do
    put 'products/update'
  end

  namespace :admin do
    resources :products
  end

  comfy_route :cms, :path => '/', :sitemap => false

end
