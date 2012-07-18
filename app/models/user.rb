class User < ActiveRecord::Base
  BASE = "BASE"
  SUPER = "SUPER"
  MASTER = "MASTER"
  USER_LEVELS = [BASE,SUPER,MASTER]

  self.primary_key = :username
end