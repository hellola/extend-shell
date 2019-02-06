Rails.application.routes.draw do
  get 'dashboard/show'
  get '/' => 'dashboard#show'

  concern :executable do
    get :exec, on: :member
    get 'execute/:name', to: 'hotkeys#exec_by_name', as: 'exec_by_name', on: :collection
  end

  resources :startups, concerns: :executable
  resources :functions, concerns: :executable
  resources :hotkeys, concerns: :executable
  resources :aliases, concerns: :executable
  resources :histories
  resources :hotkey_types
  resources :operating_systems
  resources :locations
  resources :environments
  resources :categories

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
