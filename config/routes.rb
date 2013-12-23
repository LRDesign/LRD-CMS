LrdCms::Application.routes.draw do
  namespace :admin do
    namespace :upload do
      resources :images
      resources :documents
    end
    resources :pages
    resources :locations
  end

  # resources :images, :controller => 'admin/upload/images'
  # resources :documents, :controller => 'admin/upload/documents'

  devise_for :users
  devise_scope :user do
    get "/login" => "devise/sessions#new", :as => :login
    delete "/logout" => "devise/sessions#destroy", :as => :logout
  end

  root :to => 'static#index'

  get '/*permalink', :controller => :pages, :action => 'show'
end
