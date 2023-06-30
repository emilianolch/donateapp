# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :payments do
    collection do
      get :success
      get :failure
      get :pending
      post :notification
    end
  end
end
