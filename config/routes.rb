Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # resources :user
  # resources :character

  # These routes will be for signup. The first renders a form in the browse, the second will
  # receive the form and create a user in our database using the data given to us by the user.

  # Housekeeping / General
  get '/' => 'application#index'
  get '/about' => 'application#about'
  get '/tos' => 'application#eula'
  get '/privacy' => 'application#privacy'

  # Sessions
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  # User
  get '/signup' => 'user#new'
  post '/user' => 'user#create'
  post '/user/delete' => 'user#delete'
  get '/user/:id' => 'user#show'
  get '/user/edit/:id' => 'user#edit'
  post '/user/update' => 'user#update'
  get '/user/:id/characters' => 'user#characters'
  get '/user/:id/characters/tessera' => 'character#user_tessera'

  get '/users' => 'user#index'
  get '/user' => 'user#index' # may as well alias this (shouldn't conflict with POST route for /user)



  scope module: :warehouse do
  # Character (single)
  get '/character/new' => 'character#new'
  post '/character' => 'character#create'
  get '/character/:id' => 'character#show_one'
  get '/character/edit/:id' => 'character#edit'
  post '/character/update' => 'character#update'
  get '/character/delete/:id' => 'character#delete'
  post '/character/delete' => 'character#destroy'

  # Characters (all/plural)
  get '/characters' => 'character#show'
  get '/characters/fcs' => 'character#fcs'
  get '/characters/pending' => 'character#approve_all_pending'
  post '/characters/approve' => 'character#approve'
  get '/characters/approve' => 'character#approve'
  get '/characters/fcs/pending' => 'character#approve_all_fcs'
  post '/characters/fcs/approve' => 'character#approve_fcs'

  # Checks
  get '/checks/' => 'activity_check#checks'

  # Checks - reaping
  get '/checks/reaping' => 'reaping_check#index'
  get '/checks/reaping/:games' => 'reaping_check#show_by_games'
  get '/checks/reaping/:games/add/:user_id' => 'reaping_check#add_characters'
  post '/checks/reaping/:games/add' => 'reaping_check#add'
  get '/checks/new/reaping/' => 'reaping_check#new'
  post '/checks/create/reaping/' => 'reaping_check#create'
  get '/checks/reaping/:games/tessera' => 'reaping_check#all_tessera'
  post '/checks/reaping/tessera' => 'reaping_check#update_all_tessera'

  # Checks - activity
  get '/checks/activity' => 'activity_check#index'
  get '/checks/activity/:games' => 'activity_check#show_by_games'
  get '/checks/activity/:games/add/:user_id' => 'activity_check#add_characters'
  post '/checks/activity/:games/add' => 'activity_check#add'
  get '/checks/new/activity/' => 'activity_check#new'
  post '/checks/create/activity/' => 'activity_check#create'

  end

  # Search
  get '/search' => 'search#search'


  # API Routes

  get '/api/user' => 'api#user_get_all'
  get '/api/user/:id' => 'api#user_get_by_id'
  get '/api/find/user/' => 'api#user_find'

  get '/api/character' => 'api#character_get_all'
  get '/api/character/:id' => 'api#character_get_by_id'
  get '/api/characters/active' => 'api#all_active_characters'
  get '/api/find/character/' => 'api#character_find'

  get '/api/find/' => 'api#generic_find_by_name'

  get '/api/suggestions' => 'api#search_suggest'
  get '/api/tessera' => 'api#tessera'

  # Log Routes
  get '/logs' => 'api#logs'


  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
