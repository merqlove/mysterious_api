Rails.application.routes.draw do
  apipie
  root 'welcome#index'

  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      put 'tokens', to: 'tokens#update'
      resources :users, except: [:edit, :new], concerns: :paginatable
      resources :posts, except: [:edit, :new], concerns: :paginatable do
        resources :comments, except: [:edit, :new], concerns: :paginatable

        post 'publish', on: :member
        post 'unpublish', on: :member

        post 'follow', on: :member
        post 'unfollow', on: :member
      end
    end
  end

  # mount ActionCable.server => '/cable'
end