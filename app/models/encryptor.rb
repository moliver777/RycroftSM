require 'aes'

module Encryptor
  # = AES
  # Uses the AES algorithm to encrypt passwords.
  class Aes256
    # Returns a Base64 encrypted password where pepper is used for the key,
    # and the initialization_vector is randomly generated and prepended onto
    # encoded ciphertext
    def digest(password, stretches=0)
      pepper = "KWu9h6p42AhlH21Y5owZ0i5z5CsJAO"
      ::AES.encrypt(password, pepper, {:iv => salt})
    end
    alias :encrypt :digest
    # Returns a base64 encoded salt
    def salt(stretches=0)
      ::AES.iv(:base_64)
    end
    # Returns the plaintext password where pepper is used for the key,
    # and the initialization_vector is read from the Base64 encoded ciphertext
    def decrypt(encrypted_password)
      pepper = "KWu9h6p42AhlH21Y5owZ0i5z5CsJAO"
      ::AES.decrypt(encrypted_password, pepper)
    end
  end
end