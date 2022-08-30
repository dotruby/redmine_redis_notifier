resources :event_notifications, only: [:index] do
  member do
    put :publish
  end
end
