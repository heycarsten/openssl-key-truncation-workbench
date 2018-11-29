require 'bundler/setup'
require 'active_support'
require 'openssl'
require 'workshop/bench'

module Workshop
  module_function

  def enc(key, msg, signing_key = nil)
    Bench.new.try_encrypt(key, msg, signing_key)
  end

  def dec(key, payload, signing_key = nil)
    Bench.new.try_decrypt(key, payload, signing_key)
  end

  def keygen
    Bench.new.generate_railsy_secret_key
  end

  def announce!
    Bench.new.announce!
  end
end
