class User < ActiveRecord::Base
  self.primary_key = :username
end