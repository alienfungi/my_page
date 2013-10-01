MyPage::Application.routes.draw do
  resources :activities
  resources :contact_messages, only: [:new, :create]
  resources :friendships
  resources :messages
  resources :scores
  resource :sessions
    post 'login' => 'sessions#create'
    get 'login'  => 'sessions#new'
    match '/logout', to: 'sessions#destroy', via: [:get, :post]
  resources :users

  root to: 'sessions#new'
end

