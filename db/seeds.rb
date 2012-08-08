user = User.new
user.username = "admin"
user.password = User.encrypt "password"
user.first_name = "Admin"
user.last_name = ""
user.user_level = "MASTER"
user.save!



config = Preference.new
config.name = "clock_style"
config.value = "swissRail"
config.save!

config = Preference.new
config.name = "home_report_1"
config.value = "client_events"
config.save!

config = Preference.new
config.name = "home_report_1_period"
config.value = "7"
config.save!

config = Preference.new
config.name = "home_report_2"
config.value = "horse_events"
config.save!

config = Preference.new
config.name = "home_report_2_period"
config.value = "7"
config.save!



config = SiteSetting.new
config.name = "application_status_check"
config.value = "0"
config.external = false
config.save!

config = SiteSetting.new
config.name = "block_auto_assign_prompt"
config.value = Date.today.to_time.advance(:days => -1).to_date
config.external = false
config.save!

config = SiteSetting.new
config.name = "status_check_interval"
config.value = "2"
config.external = true
config.save!

config = SiteSetting.new
config.name = "business_name"
config.value = "Rycroft School of Equitation"
config.external = true
config.save!

config = SiteSetting.new
config.name = "business_address"
config.value = "New Mill Lane, Eversley, Hampshire, RG27 0RA"
config.external = true
config.save!

config = SiteSetting.new
config.name = "business_telephone"
config.value = "01189 732 761"
config.external = true
config.save!

config = SiteSetting.new
config.name = "business_email"
config.value = "rycroft.riding@btopenworld.com"
config.external = true
config.save!
