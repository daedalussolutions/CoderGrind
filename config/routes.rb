Rails.application.routes.draw do
  get 'terms/of'
  get 'terms/Service'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resource :session
  resource :registration
  resource :password_reset
  resource :password

  resource :log_entries, only: [:index, :create, :destroy, :edit, :patch, :update]


  # Defines the root path route ("/")
   root "main#index"
   get "dashboard", to: "dashboard#index"
   get "log_entries", to: "log_entries#index"
   get "account", to: "account#index"
   get "about", to: "about#index"
   get "privacy", to: "privacy#index"
   get "terms_of_service", to: "terms_of_service#index"
end
