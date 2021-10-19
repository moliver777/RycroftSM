# encoding: utf-8

user = User.new
user.username = "admin"
user.password = User.encrypt "mgs2sol"
user.first_name = "Admin"
user.last_name = ""
user.user_level = "MASTER"
user.save!

config = Preference.new
config.name = "clock_style"
config.value = "swissRail"
config.save!

config = Preference.new
config.name = "price_list"
config.value = '<div id="price_list_content">
	<h2>Price List</h2>
	Nothing here yet!
</div>'
config.save!



config = SiteSetting.new
config.name = "application_status_check"
config.value = "0"
config.save!

config = SiteSetting.new
config.name = "block_auto_assign_prompt"
config.value = Date.today.to_time.advance(:days => -1).to_date
config.save!

config = SiteSetting.new
config.name = "event_chain_id"
config.value = "0"
config.save!

config = SiteSetting.new
config.name = "status_check_interval"
config.value = "1"
config.save!

config = SiteSetting.new
config.name = "business_name"
config.value = "Test Riding School"
config.save!

config = SiteSetting.new
config.name = "business_address"
config.value = "The School, The Road, The Town"
config.save!

config = SiteSetting.new
config.name = "business_telephone"
config.value = "01234 567 890"
config.save!

config = SiteSetting.new
config.name = "business_email"
config.value = "test@ridingschool.com"
config.save!

config = SiteSetting.new
config.name = "cash_up_password"
config.value = "password"
config.save!
