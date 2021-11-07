Rails.application.routes.draw do
  namespace 'api' do
    resources :ideas, :only => :create
    post "search" => "ideas#search"
  end
end
