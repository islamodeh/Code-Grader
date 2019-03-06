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
    resources :courses, except: [:show] do
      member do
        get :students, :handle_enrollment, :grades
      end

      resources :works do
        get "student_submissions/:id", to: "works#student_submissions", as: "student_submissions"
        resources :submissions, except: [:edit, :update, :destroy, :show]
        resources :samples, except: [:edit, :show]
      end
    end
  end

  # Student

  namespace :student do
    get "/", to: "students#index"
    resources :courses do
      member do
        post :enroll
      end
      collection do
        get :search
      end
      resources :works, only: [:index] do
        resources :submissions, except: [:edit, :update, :destroy, :show]
      end
    end
  end

  get "/help", to: "home#help"
  root "home#index"
end
