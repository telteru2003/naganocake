Rails.application.routes.draw do

  namespace :admin do
    get 'search/search'
  end

    # admin

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: { # skip オプションを使用し不要なルーティングを削除
    :sessions => 'admin/sessions',
    :registrations => 'admin/registrations',
  }

  namespace :admin do
  	get '/search'=>'search#search'
    resources :customers,only: [:index,:show,:edit,:update]
  	resources :items,only: [:index,:new,:create,:show,:edit,:update,]
  	resources :genres,only: [:index,:create,:edit,:update, :show]
  	resources :orders,only: [:index,:show,:update] do
  	  member do
        get :current_index
        resource :order_details,only: [:update]
      end
      collection do
        get :today_order_index
      end
    end
  end

  # customer

devise_for :customers,skip: [:passwords], controllers: { # skip オプションを使用し不要なルーティングを削除
    :sessions => 'public/sessions',
    :registrations => 'public/registrations',
    :passwords => 'public/passwords'
  }

  get 'about' => 'public/homes#about'
  root 'public/homes#top'
  get '/customers/contact' => 'public/customers#contact'

  scope module: :public do
    resources :items,only: [:index,:show]
    get 'search' => 'items#search'
    # deviseと衝突してしまうので、オリジナルに変更
    get 'edit/customers' => 'customers#edit'
    patch 'update/customers' => 'customers#update'

  	resource :customers,only: [:edit,:update,:show] do
  		collection do
  	     get 'quit'
  	     patch 'out'
  	  end
  	end

      resources :cart_items,only: [:index,:update,:create,:destroy] do
        collection do
          delete '/' => 'cart_items#all_destroy'
        end
      end

      resources :orders,only: [:new,:index,:show,:create] do
        collection do
          post 'confirm'
          get 'thanks'
        end
      end

      resources :addresses,only: [:index,:create,:edit,:update,:destroy]
    end
  end
