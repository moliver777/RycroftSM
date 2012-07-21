require 'encryptor'

class User < ActiveRecord::Base
  BASE = "BASE"
  SUPER = "SUPER"
  MASTER = "MASTER"
  LEVELS = [BASE,SUPER,MASTER]

  self.primary_key = :username

  def self.encrypt password
    Encryptor::Aes256.new.digest password, 0
  end

  def self.decrypt password
    Encryptor::Aes256.new.decrypt password
  end
end