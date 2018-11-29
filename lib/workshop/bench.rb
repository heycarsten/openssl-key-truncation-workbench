require 'workshop/log'

module Workshop
  class Bench
    CIPHER = 'aes-256-cbc'
    MESSAGE = 'All around me are familiar faces'

    attr_reader :log

    def initialize
      @log = Workshop::Log.new
    end

    def announce!
      log.head("Testing ActiveSupport::MessageEncryptor " \
        "[#{log.pink("Ruby #{RUBY_VERSION}")}]")
    end

    def generate_railsy_secret_key
      OpenSSL::Random.random_bytes(64).unpack('H*')[0]
    end

    def crypto_for(key, signing_key = nil)
      signing_key ||= key
      ActiveSupport::MessageEncryptor.new(key, signing_key, cipher: CIPHER)
    end

    def try_encrypt(key, msg = nil, signing_key = nil)
      msg ||= MESSAGE
      log.task("Encrypting a message")
      log.info("msg: #{msg.inspect}")
      log.info("key: #{key.inspect}")
      log.info("sig: #{signing_key ? signing_key.inspect : '<DEFAULT>'}")
      payload = crypto_for(key, signing_key).encrypt_and_sign(msg)
      log.succ('Successfully encrypted message')
      payload
    rescue => e
      log.backtrace(e)
    end

    def try_decrypt(key, payload, signing_key = nil)
      log.task("Decrypting an encrypted message")
      log.info("payload: #{payload.inspect}")
      log.info("key: #{key.inspect}")
      log.info("sig: #{signing_key ? signing_key.inspect : '<DEFAULT>'}")
      msg = crypto_for(key, signing_key).decrypt_and_verify(payload)
      log.succ('Successfully decrypted message')
      msg
    rescue => e
      log.backtrace(e)
    end
  end
end
