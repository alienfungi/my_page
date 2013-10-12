MyPage::Application.routes.draw do
  # root
  root to: 'users#home'

  # activities
  resources :activities

  # comments
  resources :comments

  # friendships
  get 'friends' => 'friendships#friends'
  get 'friendships/requests' => 'friendships#requests'
  get 'friendships/pending' => 'friendships#pending'
  resources :friendships

  # messages
  get 'messages/received' => 'messages#received'
  get 'messages/sent' => 'messages#sent'
  resources :messages

  # microposts
  resources :microposts do
    resources :comments
  end

  # sesssions
  post 'login' => 'sessions#create'
  get 'login'  => 'sessions#new'
  get 'logout' => 'sessions#destroy'
  resource :sessions

  # users
  get 'confirm' => 'users#confirm'
  get 'recover' => 'users#recover'
  resources :users

end

