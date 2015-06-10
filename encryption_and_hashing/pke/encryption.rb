require 'openssl'
require "base64"

# Ruby encryption module I created for implementing PKE in an API

module Encryption

  class << self
    # create OpenSSL keypair object, used for generated Qkey keypair
    def gen_rsa_key(size=2048)
      rsa_key = OpenSSL::PKey::RSA.new(size)
    end

    # Converts OpenSSL RSA object into pem string
    def return_as_pem(rsa_key, encrypt=false)
      if encrypt
        cipher = OpenSSL::Cipher::Cipher.new('des3')
        private_key = rsa_key.to_pem(cipher, "96y47U34r2wjeiOgrhE958")
      else
        private_key = rsa_key.to_pem
        public_key = rsa_key.public_key.to_pem
      end
      key_pair_hash = {private_key: private_key, public_key: public_key}
    end

    # returns public key in pem format
    def format_for_db(rsa_key_pair, encrypt=false)
      key_pair_hash = return_as_pem(rsa_key_pair, encrypt)
      key_pair_hash[:public_key]
    end

    # Parses key into its parts
    def return_as_params(rsa_key)
      public_hash = rsa_key.public_key.params
      private_hash = rsa_key.params

      public_key = Hash[public_hash.map{|k, v| [k, v.to_s] } ]
      private_key = Hash[private_hash.map{|k, v| [k, v.to_s] } ]
      key_pair_hash = {private_key: private_key, public_key: public_key}
    end

    # if specified as hash, it returns params
    def return_key_as(rsa_key, format="params", encrypt=false)
      if format == "pem"
        return_as_pem(rsa_key, encrypt)
      elsif format == "params" or format == nil
        return_as_params(rsa_key)
      end
    end

    # accepts PEM key, returns OpenSSL RSA object
    def restore_rsa_key(pem_key)
      OpenSSL::PKey::RSA.new(pem_key)
    end

    def convert_key_pair(key_pair_hash)
      key_pair = key_pair_hash[:private_key] + key_pair_hash[:public_key]
    end

    # sign string with qkey private key
    def sign_data(data, private_key)
      digest = OpenSSL::Digest::SHA256.new
      signature = private_key.sign(digest, data)
    end

    # verify signature with public key
    def verify_data(data, signature, public_key)
      digest = OpenSSL::Digest::SHA256.new
      public_key.verify(digest, signature, data)
    end

    def qkey_encrypt(q_key_private_key, string)
      pub_key = restore_rsa_key(q_key_private_key)
      encrypted_string = Base64.encode64(pub_key.public_encrypt(string))
    end

    def qkey_decrypt(pem_key, encrypted_string)
      private_key = restore_rsa_key(pem_key)
      string = private_key.private_decrypt(Base64.decode64(encrypted_string))
    end

    # Public Key encryption
    def generate_public_key!
      public_key_file = 'public.pem'
      @public_key = OpenSSL::PKey::RSA.new(File.read(public_key_file))
    end

    def pub_encrypt(string)
      @public_key ||= generate_public_key!
      encrypted_string = Base64.encode64(@public_key.public_encrypt(string))
    end

    def private_decrypt(encrypted_string)
      private_key_file = './private.pem'
      password = "96y47U34r2wjeiOgrhE958"
      private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file),password)
      string = private_key.private_decrypt(Base64.decode64(encrypted_string))
    end

    def private_sign(data)
      private_key_file = './private.pem'
      password = "96y47U34r2wjeiOgrhE958"
      private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file),password)

      digest = OpenSSL::Digest::SHA256.new
      signature = Base64.encode64(private_key.sign(digest, data))
    end

    # verify signature with public key
    def verify_sign(data, signature)
      public_key_file = './public.pem'
      public_key = OpenSSL::PKey::RSA.new(File.read(public_key_file))

      digest = OpenSSL::Digest::SHA256.new
      public_key.verify(digest, signature, data)
    end

    # returns key as pem or other format
    # {"public": {"N":12323512312412314, "E": 63432446, "D": 72423423423423"}, "private": ...}
    def return_public_key(format="params")
      @public_key ||= generate_public_key!
      if format == "params" or format == nil
        key_hash = @public_key.params
        return formatted_key_hash = Hash[key_hash.map{|k, v| [k, v.to_s] } ]
      elsif format == "pem"
        return @public_key.to_pem
      else
        return @public_key.send("to_"+ format)
      end
    end
  end # class methods


end


