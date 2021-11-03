Rails.application.routes.draw do
  resources :places, except: [:new, :edit]
  scope '/auth' do
    post 'signup', to: 'auth#sign_up', as: 'signup'
    get 'login', to: 'auth#login', as: 'login'
    post 'refresh', to: 'auth#refresh', as: 'refresh'
  end
end
