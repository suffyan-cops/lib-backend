Rails.application.routes.draw do
  devise_for :user, controllers: {
    sessions: 'user/sessions',
    registrations: 'user/registrations'
  }


  namespace :api do
    namespace :v1 do
      resources :book do
        collection do
          get 'getBooksAgainstUserLibrary', to: 'book#getBooksAgainstUserLibrary'
          get 'fetchBookCount', to: 'book#fetchBookCount'
          get 'fetchAvailableBooksCount', to: 'book#fetchAvailableBooksCount'
          get 'search', to: 'book#search'
          get 'fetchBooksWithReturnDate', to: 'book#fetchBooksWithReturnDate'

          get 'get_books_by_library_id', to: 'book#get_books_by_library_id'
        end
      end
      resources :member do
        collection do
          get 'fetchMemberCount', to:'member#fetchMemberCount'
          get 'search', to: 'member#search'
        end
      end
      resources :request do
        collection do
          get 'issuedBooksCount', to:'request#issuedBooksCount'
          get 'search', to: 'request#search'
       
        end
      end
      resources :user, only: [:index, :destroy, :update] do
        collection do
          get 'getReaders', to: 'user#getReaders'
          get 'search', to: 'user#search'
        end
      end
      resources :library do
        collection do
          get 'search' ,  to: 'library#search'
          get 'fetchLibraryCount', to: 'library#fetchLibraryCount'
          get 'fetchLibCount', to: 'library#fetchLibCount'
        end
      end
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check


end
