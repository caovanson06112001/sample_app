Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    resources :users
    resources :account_activations, only: :edit
    resources :password_resets, except: %i(index destroy show)
    get "/signup", to: "users#new"
    get "/static_pages/home"
    get "/static_pages/help"
    get "/static_pages/about"
    root "static_pages#home"
    get "/test", to: "static_pages#home"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
  end
end
