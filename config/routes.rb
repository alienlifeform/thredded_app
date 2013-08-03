Thredded::Application.routes.draw do
  mount Thredded::Engine => '/forum'

  mount_sextant if Rails.env.development?
  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }
  resources :users

  devise_scope :user do
    match '/auth/:provider/callback', to: 'sessions#create'
  end

  get '/auth/failure', to: redirect('/')
  get '/auth/github', as: :auth_github
  put '/identities' => 'identities#update', as: :identity
  post '/mail/receive' => 'griddler/emails#create'

  resources :preferences

  match '/login' => redirect('/users/sign_in')
  match '/log_in' => redirect('/users/sign_in')
  match '/sign_in' => redirect('/users/sign_in')
  match '/logout' => redirect('/users/sign_out')
  match '/log_out' => redirect('/users/sign_out')
  match '/forgot_password' => redirect('/users/password/new')
  match '/user/forgot_password' => redirect('/users/password/new')
  match '/user/forgot_username' => redirect('/users/password/new')

  root to: 'thredded/messageboards#index'
end
