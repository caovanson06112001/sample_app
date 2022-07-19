Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    resources :users
    get "/users/new"
    get "/static_pages/home"
    get "/static_pages/help"
    get "/static_pages/about"
    get "/test", to: "static_pages#home"
    root "static_pages#home"
  end
end
