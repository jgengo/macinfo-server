Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :sync, only: :create

  namespace :api do
  namespace :v1 do
    resources :clients, only: [:show, :index] do 
    	resources :devices, only: [:index]
    	resources :sensors, only: [:index]
    end
  end
end

end
