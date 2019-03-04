Rails.application.routes.draw do
  resources :events do
    resources :comments
  end

  root 'events#index'
  devise_for :users, controllers: {registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks'}


  get 'events/:id/RSVP', to: 'events#join', as: 'join_event'
  delete 'events/:id/RSVP', to: 'events#leave', as: 'leave_event'

  get 'users', to: 'users#index'
  get 'user/:id', to: 'users#show', as: 'user'
end
