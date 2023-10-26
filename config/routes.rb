Rails.application.routes.draw do
  devise_for :users

  root to: "questions#index"

  concern :voteable do
    member do
      patch :like
      patch :dislike
    end
  end

  resources :questions, only: %i[index show new create update destroy], concerns: [:voteable] do
    resources :answers, only: %i[create update destroy] do
      member do
        patch :best
      end
    end
  end

  resources :files, only: :destroy
  resources :rewards, only: :index
end
