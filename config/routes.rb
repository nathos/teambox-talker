ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'accounts', :action => 'create'
  map.signup '/signup', :controller => 'accounts', :action => 'new'
  map.resources :users

  map.resource :session

  map.resources :rooms, :has_many => :messages, :member => { :leave => :post }
  map.resource :session
  map.resource :account
  
  map.root :controller => "home"
end