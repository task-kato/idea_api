Rails.application.routes.draw do
  namespace 'api' do
    resources :ideas, :only => :create
    post "ideas_search" => "ideas#ideas_search"
  end
end
