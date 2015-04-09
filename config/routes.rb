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
  get '/signup' => 'user#new'
  post '/user' => 'user#create'
  post '/user/delete' => 'user#delete'

  get '/' => 'application#index'


  get '/users' => 'user#index'
  get '/user/:id' => 'user#show'
  get '/user/edit/:id' => 'user#edit'
  post '/user/update' => 'user#update'

  get '/user/:id/characters' => 'user#characters'

  # these routes are for showing users a login form, logging them in, and logging them out.
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'


  get '/character/new' => 'character#new'
  post '/character' => 'character#create'
  get '/character/:id' => 'character#show_one'
  get '/characters' => 'character#show'
  get '/characters/fcs' => 'character#fcs'
  get '/character/edit/:id' => 'character#edit'
  post '/character/update' => 'character#update'

  get '/characters/pending' => 'character#approve_all_pending'
  post '/characters/approve' => 'character#approve'
  get '/characters/approve' => 'character#approve'

  get '/characters/fcs/pending' => 'character#approve_all_fcs'
  post '/characters/fcs/approve' => 'character#approve_fcs'


  get '/checks/reaping' => 'reaping_checks#index'
  get '/checks/reaping/:id' => 'reaping_checks#show_by_id'

  get '/checks/new/reaping/' => 'reaping_checks#new'
  # get '/checks/create/reaping/' => 'reaping_checks#create'
  post '/checks/create/reaping/' => 'reaping_checks#create'

  get '/about' => 'application#about'

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
