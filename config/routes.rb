Basar::Application.routes.draw do

  root 'pages#home'

  get 'pages/selling' => 'pages#selling'
  get 'pages/selling/help' => 'pages#selling_help'
  get 'pages/faq' => 'pages#faq'
  get 'pages/presell' => 'pages#presell'
  get 'pages/presell/cake' => 'pages#presell_cake'
  get 'pages/presell/help' => 'pages#presell_help'

  get 'pages/terms' => 'pages#terms'
  get 'pages/privacy' => 'pages#privacy'
  get 'pages/contact' => 'pages#contact'
  get 'pages/about' => 'pages#about'


  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users
  post 'users/admin_create' => 'users#create', as: :user_admin_create

  get 'transactions/all' => 'transactions#index_all', as: :all_transactions
#   post 'transactions/validate_price' => 'transactions#validate_price', as: :validate_price
#  post 'transactions/validate' => 'transactions#validate', as: :validate_transaction
  resources :transactions

  get 'sellers/apply' => 'sellers#apply_form'
  put 'sellers/apply' => 'sellers#apply'
  get 'sellers/cake' => 'sellers#cake_form'
  put 'sellers/cake' => 'sellers#cake'
  get 'sellers/cakes' => 'sellers#cakes'
  get 'sellers/help' => 'sellers#help_form'
  put 'sellers/help' => 'sellers#help'

  get 'sellers/revenue' => 'sellers#revenue', as: :sellers_revenue
#   post 'sellers/validate_code' => 'sellers#validate_code', as: :validate_seller_code
  resources :sellers

  resources :tasks

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".


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
