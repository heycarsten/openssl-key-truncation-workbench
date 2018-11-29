require 'workshop/reporter'

module Workshop
  class OpenSSLBench
    CIPHER = 'aes-256-cbc'
    MESSAGE = 'All around me are familiar faces'

    attr_reader :big_key, :report

    def initialize
      @report = Workshop::Reporter.new
    end

    def announce!
      report.head("Testing ActiveSupport::MessageEncryptor " \
        "[#{report.pink("Ruby #{RUBY_VERSION}")}]")
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
      report.task("Encrypting a message")
      report.info("msg: #{msg.inspect}")
      report.info("key: #{key.inspect}")
      report.info("sig: #{signing_key ? signing_key.inspect : '<DEFAULT>'}")
      payload = crypto_for(key, signing_key).encrypt_and_sign(msg)
      report.succ('Successfully encrypted message')
      payload
    rescue => e
      report.backtrace(e)
    end

    def try_decrypt(key, payload, signing_key = nil)
      report.task("Decrypting an encrypted message")
      report.info("payload: #{payload.inspect}")
      report.info("key: #{key.inspect}")
      report.info("sig: #{signing_key ? signing_key.inspect : '<DEFAULT>'}")
      msg = crypto_for(key, signing_key).decrypt_and_verify(payload)
      report.succ('Successfully decrypted message')
      msg
    rescue => e
      report.backtrace(e)
    end
  end
end
