Rails.application.routes.draw do
  # 会員用
  # URL /members/sign_in ...
  # 会員のパスワード編集は削除
  devise_for :members, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }
  devise_scope :member do
    post "members/guest_sign_in", to: "public/sessions#guest_sign_in"
  end
  
  scope module: :public do
    root "homes#top"
    get "homes/about"
    resources :members, only: [:index, :show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
      get "followings" => "relationships#followings"
      get "followers"  => "relationships#followers"
      member do
        get :likes
      end
    end
    get "members/:id/confirm" => "members#confirm", as: "confirm"
    patch "members/:id/withdraw" => "members#withdraw", as: "withdraw"
    resources :ideas, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
      resource  :likes,    only: [:create, :destroy]
      member do
        get :likes
      end
      resources :comments, only: [:create, :destroy]
    end
    get "searches/search"
    resources :messages,      only: [:create, :destroy]
    resources :rooms,         only: [:create, :index, :show]
    resources :notifications, only: :index
    delete "destroy_all" => "notifications#destroy_all", as: "destroy_all"
  end
  
  # 管理者用
  # URL /admin/sign_in ...
  # 管理者の登録とパスワードの編集は削除
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  
  namespace :admin do
    resources :ideas, only: [:index, :show, :destroy] do
      resources :comments, only: :destroy
    end
    resources :members, only: [:index, :show, :edit, :update]
    get "searches/search"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
