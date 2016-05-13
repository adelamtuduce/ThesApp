SampleApp::Application.routes.draw do

  # match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
  # devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

# devise_scope :user do
#   get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
#   get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
# end
  root to: 'dashboard#home'
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
      get 'retrieve_teachers', to: 'teachers#retrieve_all_teachers', as: 'retrieve_teachers'
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
    end
  end

  resources :students do
    collection do
      get 'retrieve_students', to: 'students#retrieve_all_students', as: 'retrieve_students'
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
    end
  end
  resources :diploma_projects do
    collection do
      get 'student_enrolls', to: 'diploma_projects#student_enrolls', as: 'student_enrolls'
      post 'update_priorities', to: 'diploma_projects#update_priorities', as: 'update_priorities'
    end

    member do
      post 'upload_documentation', to: 'diploma_projects#upload_documentation', as: 'upload_documentation'
      get 'diploma_project_modal', to: 'diploma_projects#diploma_project_modal', as: 'diploma_project_modal'
    end
    post 'enroll', to: 'diploma_projects#enroll_student', as: 'enroll'
  end

  resources :users do
    collection do
      get 'selection_options', to: 'users#settings', as: 'selection_options'
      post 'toggle_selection', to: 'users#toggle_selection_mode', as: 'toggle_selection'
    end
    member do
    end
  end

  resources :conversations do
    resources :messages
  end
end
