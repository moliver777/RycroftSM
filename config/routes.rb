RycroftSM::Application.routes.draw do
  root :to => "home#index"

  # SEARCH
  get "/search/:search" => "home#search"
  get "/price_list" => "home#price_list"

  # SCHEDULE
  get "/schedule" => "home#schedule"
  get "/schedule/:date" => "home#schedule"
  get "/schedule/event/:event_id" => "home#event"
  get "/home_schedule/:date" => "home#home_schedule"

  # BOOKINGS
  get "/bookings" => "bookings#index"
  get "/bookings/date/:date" => "bookings#index"
  get "/bookings/upcoming/:date" => "bookings#upcoming"
  get "/bookings/new" => "bookings#new"
  post "/bookings/create" => "bookings#create"
  get "/bookings/show/:booking_id" => "bookings#show"
  get "/bookings/show_event/:event_id" => "bookings#show_event"
  post "/bookings/status/:booking_id/:status" => "bookings#status"
  get "/bookings/edit/:booking_id" => "bookings#edit"
  get "/bookings/edit_event/:event_id" => "bookings#edit"
  post "/bookings/update/:booking_id" => "bookings#update"
  post "/bookings/update_event/:event_id" => "bookings#update_event"
  post "/bookings/cancel/:booking_id" => "bookings#cancel"
  post "/bookings/cancel_event/:event_id" => "bookings#cancel_event"
  post "/bookings/delete/:booking_id" => "bookings#destroy"
  post "/bookings/delete_event/:event_id" => "bookings#destroy_event"
  get "/bookings/reload_timetable/:date/:venue_id/:event_id" => "bookings#reload_timetable"
  get "/bookings/reload_staff/:date/:staff_id/:staff_id2/:staff_id3/:event_id" => "bookings#reload_staff"
  get "/bookings/reload_horse/:date/:horse_id/:event_id" => "bookings#reload_horse"
  get "/bookings/get_event/:event_id" => "bookings#event"
  get "/bookings/get_client/:client_id" => "bookings#client"
  get "/bookings/refresh_horses/:date" => "bookings#horses"
  get "/bookings/client_search/:search" => "bookings#client_search"
  get "/bookings/search" => "bookings#search"
  get "/bookings/search_results" => "bookings#search_results"
  get "/bookings/search/:horse_id" => "bookings#auto_search"
  get "/available_now" => "bookings#available_now"
  get "/available_now/:duration/:hour/:mins" => "bookings#available_now_fields"
  post "/book_now" => "bookings#available_now_complete"
  get "/rebook/:booking_id" => "bookings#rebook"
  post "/rebook_status/:booking_id" => "bookings#rebook_status"
  get "/rebook_all/:event_id" => "bookings#rebook_all"
  get "/get_rebook_details" => "bookings#get_rebook_details"
  post "/do_rebook_all" => "bookings#do_rebook_all"

  # PAYMENTS
  get "/bookings/payment/:booking_id" => "bookings#payment"
  post "/bookings/create_payment" => "bookings#create_payment"
  post "/bookings/delete_payment/:payment_id" => "bookings#delete_payment"
  get "/other_payment" => "bookings#other_payment"
  get "/cash_up" => "bookings#cash_up"
  get "/cash_up/:date" => "bookings#cash_up"

  # CLIENTS
  get "/clients" => "clients#index"
  get "/clients/sort/:sort/:mod" => "clients#sort"
  get "/clients/new" => "clients#new"
  post "/clients/create" => "clients#create"
  get "/clients/show/:client_id" => "clients#show"
  get "/clients/edit/:client_id" => "clients#edit"
  post "/clients/update/:client_id" => "clients#update"
  post "/clients/delete/:client_id" => "clients#destroy"
  get "/clients/horses/:client_id" => "clients#horses"
  post "/clients/set_horses/:client_id" => "clients#set_horses"
  get "/clients/no_horses" => "clients#no_horses"

  # HORSES
  get "/horses" => "horses#index"
  get "/horses/sort/:sort/:mod" => "horses#sort"
  get "/horses/new" => "horses#new"
  post "/horses/create" => "horses#create"
  get "/horses/show/:horse_id" => "horses#show"
  get "/horses/edit/:horse_id" => "horses#edit"
  post "/horses/update/:horse_id" => "horses#update"
  post "/horses/delete/:horse_id" => "horses#destroy"
  post "/horses/availability/:horse_id/:value" => "horses#availability"

  # STAFF
  get "/staff" => "staff#index"
  get "/staff/sort/:sort/:mod" => "staff#sort"
  get "/staff/new" => "staff#new"
  post "/staff/create" => "staff#create"
  get "/staff/show/:staff_id" => "staff#show"
  get "/staff/edit/:staff_id" => "staff#edit"
  post "/staff/update/:staff_id" => "staff#update"
  post "/staff/delete/:staff_id" => "staff#destroy"

  # REPORTS
  get "/reports" => "reports#index"
  get "/reports/:from_date/:to_date" => "reports#change_date"

  # NOTES
  get "/notes" => "notes#index"
  get "/notes/GENERAL" => "notes#general"
  get "/notes/BOOKING" => "notes#bookings"
  get "/notes/BOOKING/:booking_id" => "notes#show_booking"
  get "/notes/CLIENT" => "notes#clients"
  get "/notes/CLIENT/:client_id" => "notes#show_client"
  get "/notes/HORSE" => "notes#horses"
  get "/notes/HORSE/:horse_id" => "notes#show_horse"
  get "/notes/STAFF" => "notes#staff"
  get "/notes/STAFF/:staff_id" => "notes#show_staff"
  get "/notes/new" => "notes#new"
  get "/notes/new/:category" => "notes#new"
  get "/notes/new/:category/:subject_id" => "notes#new"
  post "/notes/create" => "notes#create"
  get "/notes/edit/:note_id" => "notes#edit"
  post "/notes/update/:note_id" => "notes#update"
  post "/notes/delete/:note_id" => "notes#destroy"
  get "/notes/hide/:note_id" => "notes#hide"

  # ADMIN
  get "/admin" => "admin#index"
  get "/admin/users" => "users#index"
  get "/admin/users/new" => "users#new"
  post "/admin/users/create" => "users#create"
  get "/admin/users/edit/:username" => "users#edit"
  post "/admin/users/update/:username" => "users#update"
  post "/admin/users/delete/:username" => "users#destroy"
  post "/admin/users/reset_password/:username" => "users#reset_password"
  get "/admin/settings" => "admin#settings"
  post "/admin/update_settings" => "admin#update_settings"
  get "/admin/venues" => "venues#index"
  get "/admin/venues/new" => "venues#new"
  post "/admin/venues/create" => "venues#create"
  post "/admin/venues/delete/:venue_id" => "venues#destroy"
  post "/admin/clean_database" => "admin#clean_database"

  # ACCOUNT
  get "/account" => "account#index"
  post "/account/change_password" => "account#change_password"

  # AUTO-ASSIGN
  post "/assignment/auto_assign/:date" => "assignment#auto_assign"
  post "/assignment/no_more_prompts" => "assignment#block"

  # SESSION
  get "/login" => "session#login"
  post "/login" => "session#create"
  get "/logout" => "session#destroy"

  # PRINTING
  get "/print/schedule" => "printing#schedule"
  get "/print/schedule/:date" => "printing#schedule"
  get "/print/cash_up/:date" => "printing#cash_up"
  get "/print/client/:client_id" => "printing#client"
  get "/print/event/:event_id" => "printing#event"
  get "/print/booking/:booking_id" => "printing#booking"
  get "/print/reports/:from_date/:to_date" => "printing#reports"
  get "/print/end_of_day" => "printing#end_of_day"
  get "/print/end_of_day/:date" => "printing#end_of_day"

  # WELFARE
  get "/welfare" => "welfare#index"
  get "/welfare/calendar" => "welfare#calendar"
  get "/welfare/lists" => "welfare#lists"
end
