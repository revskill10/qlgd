Qlgd::Application.routes.draw do
  require 'sidekiq/web'
# ...
  mount Sidekiq::Web, at: '/sidekiq'
  
  devise_for :users
  scope '(tenants/:tenant_id)' do
    
    get "/" => "dashboard#index"
    get "/search" => 'dashboard#search'
    get '/active' => 'dashboard#monitor'
    get "calendar" => "dashboard#calendar", :as => :calendar
    get "/lich/:id" => "dashboard#lich", :as => :lich
    get "/lop/:id" => "dashboard#lop"  
    get "/daotao" => "dashboard#daotao"
    get "/thanhtra" => 'dashboard#thanhtra'
    get "/khoa" => 'dashboard#truongkhoa'
    get "/sinh_viens/:sinh_vien_id" => 'dashboard#sinh_vien'
    get "/giang_viens/:giang_vien_id" => 'dashboard#giang_vien'
    namespace :truongkhoa do 
      get "/:khoa_id" => 'giang_viens#index'
      get "/lop/:lop_id" => 'lop_mon_hocs#show'
      get "/lop/:lop_id/lichtrinh" => 'lop_mon_hocs#lichtrinh'
      get "/lop/:lop_id/tinhhinh" => 'lop_mon_hocs#tinhhinh'
      post "/update" => 'lop_mon_hocs#update'
    end
    namespace :thanhtra do      
      post "/lich_trinh_giang_days" => 'lich_trinh_giang_days#index'
      post "/lich_trinh_giang_days/dimuon" => 'lich_trinh_giang_days#dimuon'
      post "/lich_trinh_giang_days/vesom" => 'lich_trinh_giang_days#vesom'
      post "/lich_trinh_giang_days/botiet" => 'lich_trinh_giang_days#botiet'
      post "/lich_trinh_giang_days/update" => 'lich_trinh_giang_days#update'
      post "/lich_trinh_giang_days/report" => 'lich_trinh_giang_days#report'
      post "/lich_trinh_giang_days/unreport" => 'lich_trinh_giang_days#unreport'
      post "/lich_trinh_giang_days/remove" => 'lich_trinh_giang_days#remove'
      post "/lich_trinh_giang_days/confirm" => 'lich_trinh_giang_days#confirm'
      post "/lich_trinh_giang_days/restore" => 'lich_trinh_giang_days#restore'
    end
    namespace :daotao do 
      get "/lop_hanh_chinhs" => 'ghep_lop#lop_hanh_chinhs'
      get "/lop_mon_hocs" => 'ghep_lop#lop_mon_hocs'
      get "/sinh_viens" => 'ghep_lop#sinh_viens'

      post "/lop_hanh_chinhs" => 'sinh_viens#lop_hanh_chinhs'
      post "/lop_mon_hocs" => 'sinh_viens#lop_mon_hocs'      
      post "/sinh_viens" => 'sinh_viens#sinh_viens'
      get "/phongtrong/:date" => 'rooms#idle'
      post "/phongtrong" => 'rooms#idle'
      post "/move" => 'sinh_viens#move'
      delete "/lop_mon_hocs" => 'sinh_viens#remove'

      get "/lich_trinh_giang_days" => 'lich_trinh_giang_days#index'
      get "/lich_trinh_giang_days/daduyet" => 'lich_trinh_giang_days#daduyet'
      post "/lich_trinh_giang_days/accept" => 'lich_trinh_giang_days#accept'
      post "/lich_trinh_giang_days/drop" => 'lich_trinh_giang_days#drop'
      post "/lich_trinh_giang_days/check" => 'lich_trinh_giang_days#check'

      get '/lop_mon_hocs/:lop_id/calendars' => 'calendars#index'
      post '/lop_mon_hocs/:lop_id/calendars/delete' => 'calendars#remove'
      post '/lop_mon_hocs/:lop_id/calendars/generate' => 'calendars#generate'
      post '/lop_mon_hocs/:lop_id/calendars/restore' => 'calendars#restore'
      post '/lop_mon_hocs/:lop_id/calendars/add' => 'calendars#create'
      post '/lop_mon_hocs/:lop_id/calendars/destroy' => 'calendars#destroy'

      get '/lops' => 'lop_mon_hocs#index'
      post '/lop_mon_hocs/create' => 'lop_mon_hocs#create'
      post '/lop_mon_hocs/start' => 'lop_mon_hocs#start'
      post '/lop_mon_hocs/remove' => 'lop_mon_hocs#remove'
      post '/lop_mon_hocs/restore' => 'lop_mon_hocs#restore'
      post '/lop_mon_hocs/update' => 'lop_mon_hocs#update'
      
      get '/lop_mon_hocs/:lop_id/assistants' => 'assistants#index'
      post '/lop_mon_hocs/:lop_id/assistants/delete' => 'assistants#delete'
      post '/lop_mon_hocs/:lop_id/assistants/create' => 'assistants#create'
      post '/lop_mon_hocs/:lop_id/assistants/update' => 'assistants#update'

      get '/giang_viens' => 'giang_viens#index'
      post '/mon_hocs/create' => 'mon_hocs#create'

      get '/users' => 'users#index'
    end
    namespace :teacher do 
     
      #get '/' => 'static_pages#home'
      get "lich/:lich_id/attendances" => "attendances#index"
      post "lich/:lich_id/attendances" => "attendances#update"
      get "lich/:lich_id/noidung" => 'attendances#getnoidung'
      post "lich/noidung" => "attendances#noidung"
      post "lich/:lich_id/settinglop" => "attendances#settinglop"
      

      get "lops" => "lop_mon_hocs#index"
      get "lop/:lop_id/info" => "lop_mon_hocs#info"
      get "lop/:id/show" => "lop_mon_hocs#show"
      post "lop/settinglop" => "lop_mon_hocs#update"  

      get 'lop/:id/assignments' => "assignments#index"
      post 'lop/:id/assignments' => "assignments#create"
      post 'lop/:id/reorder_assignments' => "assignments#reorder"
      put 'lop/:id/assignments' => 'assignments#update'
      delete 'lop/:id/assignments' => "assignments#delete"

      post 'lop/:id/assignment_groups' => "assignment_groups#create"
      delete 'lop/:id/assignment_groups' => "assignment_groups#delete"
      put 'lop/:id/assignment_groups' => 'assignment_groups#update'  
      post 'lop/:id/reorder_assignment_groups' => 'assignment_groups#reorder'

      get '/lop/:id/group_submissions' => 'group_submissions#index'

      get '/lop/:id/submissions2' => 'submissions#index2'
      get '/lop/:id/submissions' => 'submissions#index'
      post '/lop/:id/submissions/diem_chuyen_can' => 'submissions#diem_chuyen_can'
      post '/lop/:id/submissions' => 'submissions#update'
      post '/lop/:lop_id/submissions2' => 'submissions#update2'

      get "lich/:lich_id/info" => "lich_trinh_giang_days#info"
      get '/lop/:lop_id/lich_trinh_giang_days' => 'lich_trinh_giang_days#index'
      get '/lop/:lop_id/lich_trinh_giang_days/bosung' => 'lich_trinh_giang_days#index_bosung'
      post '/lop/:lop_id/lich_trinh_giang_days/create_bosung' => 'lich_trinh_giang_days#create_bosung'
      put '/lop/:lop_id/lich_trinh_giang_days/update_bosung' => 'lich_trinh_giang_days#update_bosung'
      delete '/lop/:lop_id/lich_trinh_giang_days/remove_bosung' => 'lich_trinh_giang_days#remove_bosung'
      post '/lop/:lop_id/lich_trinh_giang_days/restore_bosung' => 'lich_trinh_giang_days#restore_bosung'
      post '/lop/:lop_id/lich_trinh_giang_days/nghiday' => 'lich_trinh_giang_days#nghiday'
      post '/lop/:lop_id/lich_trinh_giang_days/unnghiday' => 'lich_trinh_giang_days#unnghiday'
      post '/lop/:lop_id/lich_trinh_giang_days/complete' => 'lich_trinh_giang_days#complete'
      post '/lop/:lop_id/lich_trinh_giang_days/uncomplete' => 'lich_trinh_giang_days#uncomplete'
      post '/lop/:lop_id/lich_trinh_giang_days/accept' => 'lich_trinh_giang_days#accept'
      post '/lop/:lop_id/lich_trinh_giang_days/remove' => 'lich_trinh_giang_days#remove'
      post '/lop/:lop_id/lich_trinh_giang_days/restore' => 'lich_trinh_giang_days#restore'
      post '/lop/:lop_id/lich_trinh_giang_days/update' => 'lich_trinh_giang_days#update'
      post '/lop/:lop_id/lich_trinh_giang_days/capnhat' => 'lich_trinh_giang_days#capnhat'
      get '/lop/:lop_id/lich_trinh_giang_days/content' => 'lich_trinh_giang_days#getcontent'
      post '/lop/:lop_id/lich_trinh_giang_days/content' => 'lich_trinh_giang_days#content'
      get '/lich_trinh_giang_days' => 'lich_trinh_giang_days#home'
      get "/lich_trinh_giang_days/thanhtra" => 'lich_trinh_giang_days#thanhtra'
      post "/lich_trinh_giang_days/thanhtraupdate" => 'lich_trinh_giang_days#thanhtraupdate'
      post "/lich_trinh_giang_days/accept" => 'lich_trinh_giang_days#accept'
      post "/lich_trinh_giang_days/request" => 'lich_trinh_giang_days#request2'
      get '/lich_trinh_giang_days/:lich_id/mobile_content' => 'lich_trinh_giang_days#get_mobile_content'
      post '/lich_trinh_giang_days/mobile_content' => 'lich_trinh_giang_days#mobile_content'
      get '/monitor' => 'lich_trinh_giang_days#monitor'
    end
  end
  match '*a', :to => 'application#routing'
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
  root :to => 'dashboard#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
