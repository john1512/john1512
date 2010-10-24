Refinery::Application.routes.draw do
  resources :helps

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :helps do
      collection do
        post :update_positions
      end
    end
  end
end
