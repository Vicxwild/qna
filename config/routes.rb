Rails.application.routes.draw do
  devise_for :users

  root to: "questions#index"

  resources :questions, only: %i[index show new create update destroy] do
    resources :answers, only: %i[create update destroy] do
      member do
        patch :best
      end
    end
  end
end
