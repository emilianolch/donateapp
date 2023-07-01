# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :payments, only: :create do
    collection do
      get :success
      get :failure
      get :pending
      post :notification
    end
  end

  resources :donations, only: [:index, :show, :update, :destroy]
end
