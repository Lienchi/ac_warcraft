Rails.application.routes.draw do
  namespace :admin do
    get 'instances/index'
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks", confirmations: "confirmations" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  authenticated :user do
    root "missions#dashboard"
  end

  root 'public#landing'
  get 'story', :to => 'public#story'
  resources :announcements, only: [:show]
  resources :notifications do
    collection do
      post :mark_as_checked_all
      post :mark_as_read_all
    end
    member do
      post :mark_as_read
    end
  end
  resources :invitations, only: [:index, :show] do
    member do
      post :accept
      post :decline
      post :cancel
      post :read_all_msg
    end
    collection do
      get :sent_index
    end
    resources :invite_msgs, only: [:create]
  end
  resources :invite_msgs, only: [:show]
  resources :instances, only: [:show, :edit] do
    member do
      post :submit
      patch :submit  #任務完成，提交答案
      post :save
      post :cancel   #取消組隊
      post :abort    #放棄任務
    end

    collection do
      get :history
    end
    resources :instance_msgs, only: [:create]
  end

  resources :followships, only: [:create, :destroy]

  resources :missions, only: [:index, :show] do
    member do
      get :dashboard
      post :challenge
      get :select_user
      # POST challenge_mission_path 挑戰本任務
    end

    collection do
      get :teaming
    end
  end

  resources :reviews, only: [:index, :show] do
    member do
      patch :submit
    end
  end

  resources :users do
    member do
      post :invite
      get :repos
    end
  end

  namespace :admin do
    root "missions#index"
    resources :missions
    resources :instances, only: [:index]
    resources :announcements
  end

  resources :recruit_boards, only: [:index, :create, :destroy] do
    member do
      post :accept
    end
  end

  mount ActionCable.server => '/cable'

end
