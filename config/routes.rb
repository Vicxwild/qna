Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: {omniauth_callbacks: "oauth_callbacks"}

  root to: "questions#index"

  concern :voteable do
    member do
      patch :like
      patch :dislike
      patch :revote
    end
  end

  concern :commentable do
    member { patch :add_comment }
  end

  resources :questions, only: %i[index show new create update destroy], concerns: [:voteable, :commentable] do
    resources :answers, only: %i[create update destroy], concerns: [:voteable, :commentable] do
      member do
        patch :best
      end
    end
  end

  resources :files, only: :destroy
  resources :rewards, only: :index

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection # id doesn't include in url (on: :member - include id)
        get :others, on: :collection
      end

      resources :questions, only: %i[index show]
    end
  end

  mount ActionCable.server => "/cable"
end
