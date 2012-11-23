CycomTournament::Application.routes.draw do |map|
  resources :rounds

  resources :trees do
    get :generate, :on => :member
  end

  resources :groups, :only => [ :show ] do
    get :generate_games, :on => :member
  end
  resources :rankings do
    get :generate_games, :on => :member
  end
  resources :subscriptions, :only => [ :create, :destroy ]
  resources :tournaments do
    get :start, :on => :member
  end
  resources :events
  resources :memberships, :only => [ :create, :destroy ]
  resources :teams
  resources :posts
  resources :users
  resources :branches
  
  match 'login' => "sessions#create"
  match 'logout' => "sessions#destroy"

  root :to => "posts#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
