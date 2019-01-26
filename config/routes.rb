Rails.application.routes.draw do
  devise_for :students
  devise_for :instructors
  resources :instructors, :students
  root "home#index"
end
