Rails.application.routes.draw do
  devise_for :users

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

  mount ActionCable.server => "/cable"
end
