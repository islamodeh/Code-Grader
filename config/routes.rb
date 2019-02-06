Rails.application.routes.draw do
  
  devise_for :instructor, skip: :registrations
  devise_scope :instructor do
    resource :registration,
      only: [:new, :create, :edit, :update],
      path: "instructors",
      path_names: { new: "sign_up" },
      controller: "devise/registrations",
      as: :instructor_registration do
        get :cancel
      end
  end
  
  devise_for :student, skip: [:registrations]
  devise_scope :student do
    resource :registration,
      only: [:new, :create, :edit, :update],
      path: "students",
      path_names: { new: "sign_up" },
      controller: "devise/registrations",
      as: :student_registration do
        get :cancel
      end
  end
  
  # Instructor

  namespace :instructor do
    get "/", to: "instructors#index"
    resources :courses do
      get "students", to: "students"
      get "handle_enrollment", to: "handle_enrollment"
      resources :works do
        resources :submissions
      end
    end
  end

  # Student

  namespace :student do
    get "/", to: "students#index"
    get "/course/search", to: "courses#search"
    resources :courses do
      post "enroll", to: "enroll"
      resources :works do
        resources :submissions
      end
    end
  end

  root "home#index"
end
