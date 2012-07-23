RycroftSM::Application.routes.draw do
  root :to => "home#index"

  # SEARCH
  get "/search/:search" => "home#search"

  # SCHEDULE
  get "/schedule" => "home#schedule"
  # get "/schedule/:date" => "home#schedule_date"
  # get "/schedule/event/:event_id" => "home#event"

  # BOOKINGS
  get "/bookings" => "bookings#index"
  get "/bookings/new" => "bookings#new"
  # post "/bookings/create" => "bookings#create"
  # get "/bookings/edit" => "bookings#edit"
  # get "/bookings/edit/:booking_id" => "bookings#show"
  # post "/bookings/update/:booking_id" => "bookings#update"
  # get "/bookings/cancel" => "bookings#cancel"
  # get "/bookings/cancel/:booking_id" => "bookings#cancel_info"
  # post "/bookings/cancel/:booking_id" => "bookings#destroy"

  # CLIENTS
  get "/clients" => "clients#index"
  get "/clients/sort/:sort/:mod" => "clients#sort"
  get "/clients/new" => "clients#new"
  post "/clients/create" => "clients#create"
  get "/clients/show/:client_id" => "clients#show"
  get "/clients/edit/:client_id" => "clients#edit"
  post "/clients/update/:client_id" => "clients#update"
  post "/clients/delete/:client_id" => "clients#destroy"

  # HORSES
  get "/horses" => "horses#index"
  get "/horses/sort/:sort/:mod" => "horses#sort"
  get "/horses/new" => "horses#new"
  post "/horses/create" => "horses#create"
  get "/horses/show/:horse_id" => "horses#show"
  get "/horses/edit/:horse_id" => "horses#edit"
  post "/horses/update/:horse_id" => "horses#update"
  post "/horses/delete/:delete_id" => "horses#destroy"
  post "/horses/availability/:horse_id/:value" => "horses#availability"

  # STAFF
  get "/staff" => "staff#index"
  get "/staff/sort/:sort/:mod" => "staff#sort"
  get "/staff/new" => "staff#new"
  post "/staff/create" => "staff#create"
  get "/staff/edit/:staff_id" => "staff#edit"
  post "/staff/update/:staff_id" => "staff#update"
  post "/staff/delete/:staff_id" => "staff#destroy"

  # REPORTS
  get "/reports" => "reports#index"
  # get "/reports/bookings" => "reports#bookings"
  # get "/reports/clients/:client_id" => "reports#client"
  # get "/reports/horses/:horse_id" => "reports#horse"
  # get "/reports/staff/:staff_id" => "reports#staff"

  # NOTES
  get "/notes" => "notes#index"
  get "/notes/general" => "notes#general"
  get "/notes/bookings" => "notes#bookings"
  # get "/notes/bookings/:booking_id" => "notes#show_booking"
  get "/notes/clients" => "notes#clients"
  # get "/notes/clients/:client_id" => "notes#show_client"
  get "/notes/horses" => "notes#horses"
  # get "/notes/horses/:horse_id" => "notes#show_horse"
  get "/notes/staff" => "notes#staff"
  # get "/notes/staff/:staff_id" => "notes#show_staff"
  # get "/notes/new" => "notes#new"
  # post "/notes/create" => "notes#create"
  # get "/notes/edit/:note_id" => "notes#edit"
  # post "/notes/update/:note_id" => "notes#update"
  # post "/notes/delete/:note_id" => "notes#destroy"

  # ADMIN
  get "/admin" => "admin#index"
  get "/admin/users" => "users#index"
  get "/admin/users/new" => "users#new"
  post "/admin/users/create" => "users#create"
  get "/admin/users/edit/:username" => "users#edit"
  post "/admin/users/update/:username" => "users#update"
  post "/admin/users/delete/:username" => "users#destroy"
  post "/admin/users/reset_password/:username" => "users#reset_password"
  get "/admin/preferences" => "admin#preferences"
  # post "/admin/update_preferences" => "admin#update_preferences"
  get "/admin/site_settings" => "admin#site_settings"
  # post "/admin/update_site_settings" => "admin#update_site_settings"
  get "/admin/venues" => "venues#index"
  get "/admin/venues/new" => "venues#new"
  post "/admin/venues/create" => "venues#create"
  get "/admin/venues/edit/:venue_id" => "venues#edit"
  post "/admin/venues/update/:venue_id" => "venues#update"
  post "/admin/venues/delete/:venue_id" => "venues#destroy"

  # ACCOUNT
  get "/account" => "account#index"
  post "/account/change_password" => "account#change_password"

  # SESSION
  get "/login" => "session#login"
  post "/login" => "session#create"
  get "/logout" => "session#destroy"
end
