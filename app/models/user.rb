require 'encryptor'

class User < ActiveRecord::Base
  BASE = "BASE"
  SUPER = "SUPER"
  MASTER = "MASTER"
  
  LEVELS = [BASE,SUPER,MASTER]

  def change_password password
    self.password = User.encrypt(password)
    self.save
  end

  def reset_password
    self.password = User.encrypt("password")
    self.save
  end

  def set_fields fields
    self.username = fields[:username]
    self.first_name = fields[:first_name]
    self.last_name = fields[:last_name]
    self.user_level = fields[:user_level]
    self.password = User.encrypt("password") unless self.password

    self.save
  end

  def self.encrypt password
    Encryptor::Aes256.new.digest password, 0
  end

  def self.decrypt password
    Encryptor::Aes256.new.decrypt password
  end
end