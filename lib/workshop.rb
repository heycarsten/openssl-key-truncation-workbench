require 'bundler/setup'
require 'active_support'
require 'ap'
require 'openssl'
require 'securerandom'
require 'workshop/openssl_bench'

module Workshop
  module_function

  def enc(key, msg, signing_key = nil)
    OpenSSLBench.new.try_encrypt(key, msg, signing_key)
  end

  def dec(key, payload, signing_key = nil)
    OpenSSLBench.new.try_decrypt(key, payload, signing_key)
  end

  def keygen
    OpenSSLBench.new.generate_railsy_secret_key
  end

  def announce!
    OpenSSLBench.new.announce!
  end
end
