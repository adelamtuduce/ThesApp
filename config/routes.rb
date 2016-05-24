SampleApp::Application.routes.draw do

  # match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
  # devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

# devise_scope :user do
#   get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
#   get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
# end
  namespace :admin do
    get 'admin_chart_data', to: 'admin_dashboard#admin_chart_data', as: 'admin_chart_data'
    get 'view_data', to: 'admin_dashboard#view_data', as: 'view_data'
    get 'retrieve_teachers', to: 'admin_dashboard#retrieve_all_teachers', as: 'retrieve_teachers'
    get 'retrieve_students', to: 'admin_dashboard#retrieve_all_students', as: 'retrieve_students'
    get 'show_all_users', to: 'admin_dashboard#show_all_users', as: 'show_all_users'
    get 'export_to_csv', to: 'admin_dashboard#export_to_csv', as: 'export_to_csv'
  end
  root to: 'dashboard#root'
  # match '/signup',  to: 'users#new',            via: 'get'
  # match '/signin',  to: 'sessions#new',         via: 'get'
  # match '/signout', to: 'sessions#destroy',     via: 'delete'
  match '/help',    to: 'dashboard#help',    via: 'get'
  match '/about',   to: 'dashboard#about',   via: 'get'
  match '/contact', to: 'dashboard#contact', via: 'get'
  match '/auth/wsfed/callback' => 'sessions#create', via: [:get, :post]  
  match '/auth/failure' => 'sessions#failure', via: [:get]

  get '/dropbox_authorize' => 'dashboards#authorize', as: 'dropbox_authorize'
  get '/dropbox_unauthorize' => 'dashboards#unauthorize', as: 'dropbox_unauthorize'
  get '/dropbox_path_change' => 'dashboards#dropbox_path_change', as: 'dropbox_path_change'
  get '/dropbox_callback' => 'dashboards#dropbox_callback', as: 'dropbox_callback'
  get '/dropbox_download' => 'dashboards#dropbox_download', as: 'dropbox_download'
  post '/dropbox_upload' => 'dashboards#upload', as: 'upload'
  post '/dropbox_search' => 'dashboards#search', as: 'search'

  get 'preview_projects', to: 'dashboard#show_all_projects', as: 'preview_projects'
  
  resources :personal_informations do
    collection do
    end
    member do
      post :update, to: 'personal_informations#update', as: 'update'
      post 'toggle_notifications', to: 'personal_informations#toggle_notifications', as: 'toggle_notifications'
      post 'toggle_emails', to: 'personal_informations#toggle_emails', as: 'toggle_emails'
    end
  end

  # app/config/routes.rb
  devise_for :users, :controllers => {:registrations => "registrations"}

  resources :events do
    collection do
      get 'db_action', to: 'events#db_action', as: 'db_action'
    end
  end
  resources :teachers do
    collection do
      get 'start_import_parser', to: 'teachers#start_import_parser', as: 'start_import_parser'
    end
    member do
      get 'students', to: 'teachers#show_students', as: 'students'
      get 'projects', to: 'teachers#show_projects', as: 'projects'
      get 'own_dashboard', to: 'teachers#own_dashboard', as: 'own_dashboard'
      get 'retrieve_own_events', to: 'teachers#retrieve_own_events', as: 'retrieve_own_events'
      get 'retrieve_projects', to: 'teachers#retrieve_projects', as: 'retrieve_projects'
      get 'enrolls', to: 'teachers#enrollment_requests', as: 'enrolls'
      get 'show_enrollments', to: 'teachers#show_enrollments', as: 'show_enrollments'
      get 'accepted_requests', to: 'teachers#accepted_requests', as: 'accepted_requests'
      get 'accept_enrollment', to: 'teachers#accept_student_enrollment', as: 'accept_student_enrollment'
      post 'decline_enrollment', to: 'teachers#decline_student_enrollment', as: 'decline_student_enrollment'
      post 'import_projects', to: 'teachers#import_projects', as: 'import_projects'
      get 'show_import_modal', to: 'teachers#show_import_modal', as: 'show_import_modal'
      get 'retrieve_charts_data', to: 'teachers#retrieve_charts_data', as: 'retrieve_charts_data'
    end
  end

  resources :students do
    collection do
    end

    member do
      get 'student_dasboard', to: 'students#student_dasboard', as: 'student_dasboard'
      get 'projects_to_enroll', to: 'students#projects_to_enroll', as: 'projects_to_enroll'
    end
  end

  resources :documents
  resources :notifications
  resources :enroll_requests do
    member do
      delete 'destroy', to: 'enroll_requests#destroy', as: 'destroy'
      get 'overview', to: 'enroll_requests#overview', as: 'overview'
      get 'display_tabbed_content', to: 'enroll_requests#display_tabbed_content', as: 'display_tabbed_content'
    end
  end
  resources :diploma_projects do
    collection do
      get 'student_enrolls', to: 'diploma_projects#student_enrolls', as: 'student_enrolls'
      post 'update_priorities', to: 'diploma_projects#update_priorities', as: 'update_priorities'
      get 'retrieve_documentations', to: 'diploma_projects#retrieve_documentations', as: 'retrieve_documentations'
    end

    member do
      get 'diploma_project_modal', to: 'diploma_projects#diploma_project_modal', as: 'diploma_project_modal'
      post 'upload_documentation', to: 'diploma_projects#upload_documentation', as: 'upload_documentation'
      get 'show_upload_modal', to: 'diploma_projects#show_upload_modal', as: 'show_upload_modal'
      post 'submit_enroll', to: 'diploma_projects#submit_enroll', as: 'submit_enroll'
    end
    post 'enroll', to: 'diploma_projects#enroll_student', as: 'enroll'
  end

  resources :users do
    collection do
      get 'selection_options', to: 'users#settings', as: 'selection_options'
      post 'toggle_selection', to: 'users#toggle_selection_mode', as: 'toggle_selection'
    end
    member do
      post 'update_personal_information', to: 'users#update_personal_information', as: 'update_personal_information'
    end
  end

  resources :conversations do
    resources :messages
  end
end
