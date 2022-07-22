Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    resources :account_activations, only: [:edit]
    resources :users
    get "/signup", to: "users#new"
    get "/static_pages/home"
    get "/static_pages/help"
    get "/static_pages/about"
    get "/test", to: "static_pages#home"
    root "static_pages#home"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
  end
end

