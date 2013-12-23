Qlgd::Application.routes.draw do
  devise_for :users
  get "/" => "dashboard#index"
  get "calendar" => "dashboard#calendar", :as => :calendar
  get "about" => "static_pages#about"
  get "/lich/:id" => "dashboard#show", :as => :lich
  get "/diemdanh" => "dashboard#diemdanh", :as => :diemdanh
  #get '/' => 'static_pages#home'
  get "lich/:lich_id/enrollments" => "enrollments#index"
  post "lich/:lich_id/enrollments" => "enrollments#update"
  get "lich/:lich_id/info" => "lich_trinh_giang_days#info"
  get "lop/:lop_id/info" => "lop_mon_hocs#info"
  resources :tenants do 
    resources :giang_viens
    resources :sinh_viens
    resources :users
  end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
