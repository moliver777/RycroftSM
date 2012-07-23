user = User.new
user.username = "admin"
user.password = User.encrypt "password"
user.first_name = "Admin"
user.last_name = ""
user.user_level = "MASTER"
user.save!