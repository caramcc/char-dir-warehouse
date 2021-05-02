Rails.application.routes.draw do
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
  get '/characters/fcs/list' => 'character#fc_list'
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

  get '/api/attacks' => 'api#attacks'
  get '/api/attack/:code' => 'api#attack'

  get '/reaping' => 'api#reaping'
  get '/reaping/list' => 'api#reaping_list'

  # Slack API Routes
  get '/slack/attack' => 'slack#slack_attack'
  get '/slack/bio' => 'slack#slack_bio'
  get '/slack/member' => 'slack#slack_member'

end
