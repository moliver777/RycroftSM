RycroftSM::Application.routes.draw do
  root :to => "home#index"

  # SCHEDULE
  get "/schedule" => "home#schedule"
  get "/schedule/:date" => "home#schedule_date"
  get "/schedule/event/:event_id" => "home#event"

  # BOOKINGS
  get "/bookings" => "bookings#index"
  get "/bookings/new" => "bookings#new"
  post "/bookings/create" => "bookings#create"
  get "/bookings/edit" => "bookings#edit"
  get "/bookings/edit/:booking_id" => "bookings#show"
  post "/bookings/update/:booking_id" => "bookings#update"
  get "/bookings/cancel" => "bookings#cancel"
  get "/bookings/cancel/:booking_id" => "bookings#cancel_info"
  post "/bookings/cancel/:booking_id" => "bookings#destroy"

  # CLIENTS
  get "/clients" => "clients#index"
  get "/clients/new" => "clients#new"
  post "/clients/create" => "clients#create"
  get "/clients/edit" => "clients#edit"
  get "/clients/edit/:client_id" => "clients#show"
  post "/clients/update/:client_id" => "clients#update"
  get "/clients/delete" => "clients#remove"
  get "/clients/delete/:delete_id" => "clients#remove_info"
  post "/clients/delete/:delete_id" => "clients#destroy"

  # HORSES
  get "/horses" => "horses#index"
  get "/horses/new" => "horses#new"
  post "/horses/create" => "horses#create"
  get "/horses/edit" => "horses#edit"
  get "/horses/edit/:horse_id" => "horses#show"
  post "/horses/update/:horse_id" => "horses#update"
  get "/horses/delete" => "horses#remove"
  get "/horses/delete/:delete_id" => "horses#remove_info"
  post "/horses/delete/:delete_id" => "horses#destroy"
  get "/horses/availability" => "horses#availability"
  get "/horses/availability/:horse_id" => "horses#edit_availability"
  post "/horses/availability/:horse_id" => "horses#set_availability"

  # WELFARE
  get "/horses/welfare" => "welfare#index"
  get "/horses/welfare/:horse_id" => "welfare#show"
  get "/horses/welfare/edit/:horse_id" => "welfare#edit"
  post "/horses/welfare/update/:horse_id" => "welfare#update"

  # STAFF
  get "/staff" => "staff#index"
  get "/staff/new" => "staff#new"
  post "/staff/create" => "staff#create"
  get "/staff/edit" => "staff#edit"
  get "/staff/edit/:staff_id" => "staff#show"
  post "/staff/update/:staff_id" => "staff#update"
  get "/staff/delete" => "staff#remove"
  get "/staff/delete/:delete_id" => "staff#remove_info"
  post "/staff/delete/:delete_id" => "staff#destroy"

  # REPORTS
  get "/reports" => "reports#index"
  get "/reports/bookings" => "reports#bookings"
  get "/reports/clients/:client_id" => "reports#client"
  get "/reports/horses/:horse_id" => "reports#horse"
  get "/reports/staff/:staff_id" => "reports#staff"

  # NOTES
  get "/notes" => "notes#index"
  get "/notes/bookings" => "notes#bookings"
  get "/notes/clients" => "notes#clients"
  get "/notes/horses" => "notes#horses"
  get "/notes/staff" => "notes#staff"
  get "/notes/new" => "notes#new"
  post "/notes/create" => "notes#create"
  get "/notes/edit/:note_id" => "notes#edit"
  post "/notes/update/:note_id" => "notes#update"
  post "/notes/delete/:note_id" => "notes#destroy"

  # ADMIN
  get "/admin" => "admin#index"
  get "/admin/users" => "users#index"
  get "/admin/users/new" => "users#new"
  post "/admin/users/create" => "users#create"
  get "/admin/users/edit/:username" => "users#edit"
  post "/admin/users/update/:username" => "users#update"
  post "/admin/users/delete/:username" => "users#destroy"
  get "/admin/preferences" => "admin#preferences"
  post "/admin/update_preferences" => "admin#update_preferences"
  get "/admin/site_settings" => "admin#site_settings"
  post "/admin/update_site_settings" => "admin#update_site_settings"
  get "/admin/venues" => "venues#index"
  get "/admin/venues/new" => "venues#new"
  post "/admin/venues/create" => "venues#create"
  get "/admin/venues/edit/:venue_id" => "venues#edit"
  post "/admin/venues/update/:venue_id" => "venues#update"
  post "/admin/venues/delete/:venue_id" => "venues#destroy"

  # ACCOUNT
  get "/account" => "account#index"
  get "/account/edit" => "account#edit"
  post "/account/update" => "account#update"

  # SESSION
  get "/login" => "session#login"
  post "/login" => "session#create"
  get "/logout" => "session#destroy"
end
