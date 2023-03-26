Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "tasks#index"

  resources :tasks

  post "/tasks/priority", to: "tasks#set_priority"
  post "/tasks/:id/complete", to: "tasks#update_completed_status"
end
