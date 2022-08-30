resources :redis_notifications, only: [:index, :show] do
  member do
    put :publish
  end
end
