SampleApp::Application.routes.draw do

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
    end
  end

  # app/config/routes.rb
  devise_for :users, :controllers => {:registrations => "registrations"}

  resources :events
  resources :teachers do
    member do
      get 'students', to: 'teachers#show_students', as: 'students'
      get 'projects', to: 'teachers#show_projects', as: 'projects'
      get 'retrieve_projects', to: 'teachers#retrieve_projects', as: 'retrieve_projects'
      get 'enrolls', to: 'teachers#enrollment_requests', as: 'enrolls'
      get 'show_enrollments', to: 'teachers#show_enrollments', as: 'show_enrollments'
      get 'accepted_requests', to: 'teachers#accepted_requests', as: 'accepted_requests'
      get 'accept_enrollment', to: 'teachers#accept_student_enrollment', as: 'accept_student_enrollment'
      post 'decline_enrollment', to: 'teachers#decline_student_enrollment', as: 'decline_student_enrollment'
    end
  end

  resources :documents
  resources :diploma_projects do
    post 'enroll', to: 'diploma_projects#enroll_student', as: 'enroll'
  end

  resources :users do
    member do
    end
  end

  resources :conversations do
    resources :messages
  end
end
