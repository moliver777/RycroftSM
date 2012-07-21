user = User.new
user.username = "schettle"
user.password = User.encrypt "password"
user.first_name = "Sarah"
user.last_name = "Chettle"
user.user_level = "MASTER"
user.save!