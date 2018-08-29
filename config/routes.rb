Rails.application.routes.draw do
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  
  resources :sessions
  resources :reports
  resources :wit_ai_uploads, :only => [:index]
  post '/wit_ai_uploads/new_upload' => 'wit_ai_uploads#create'
  get '/wit_ai_uploads/confirm_import' => 'wit_ai_uploads#confirm_import'
  get '/wit_ai_uploads/show_data' => 'wit_ai_uploads#show'
  
  root to: 'sessions#new'
end
