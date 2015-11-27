Rails.application.routes.draw do
  resources :signup, only: [:index, :create]

  get 'clearance/users#new' => redirect('/signup')
  get 'sign_up' => redirect('/signup'), as: :signup

  resources :people, only: [:index, :show]
end
