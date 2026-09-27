# URLとアクションメソッドの紐付け
Rails.application.routes.draw do
  get "hoge/index"
  get "hoge/show"
  get "hoge/new"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # URL => 対応アクション
  get "hello" => "hello#index" # ex) helloコントローラのindexアクションを呼び出す

  get "hello/view" # 省略形

  get "hello/list"

  get "hello/test" => "hello#test"
end

