Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      resources :books
      resources :reading_lists do
        member do
          post :add_books
          delete :remove_books
          put :update_book
          get :export_to_yaml
          post :export_to_pantry
        end
      end
    end
  end
end
