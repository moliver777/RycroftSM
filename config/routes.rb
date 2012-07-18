RycroftSM::Application.routes.draw do
  root :to => "home#index"

  get "/login" => "session#login"
  post "/login" => "session#create"
  get "/logout" => "session#logout"
end
