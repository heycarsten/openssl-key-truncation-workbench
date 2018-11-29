# OpenSSL Key Truncation Investigation (via ActiveSupport::MessageEncryptor)

In Ruby > 2.3 openssl rejects keys larger than the requested cypher allows,
this means keys that were working no longer do, what needs to be done to a key
so that it works again? Is it even possible? YES! (see: Answer)

## Using

1. You'll need to install [RVM](https://rvm.io)
2. `script/run-tests`

![](https://snappities.s3.amazonaws.com/wy5151v522c591r2f41b.png)

## Answer

Turns out the truncated key was only half the story.
`ActiveSupport::MessageEncryptor` takes a second argument, this is the signing
key, by default the secret key is used as the signing key. When the secret key
is truncated to 32 bytes (required length for AES-256-CBC) then this value is
_also_ used as the signing key and decryption can not happen successfully.

The solution is to truncate the secret key to 32 bytes, AND explicitly pass
the signing key as the original value:

```ruby
# Before Ruby 2.4 when OpenSSL silently truncated secret keys:
long_key = '23rwfnlknf8923nfaelrjnf23nfaewrinflaekrn932fiueranljkgniu3n4fkeuya'
ActiveSupport::MessageEncryptor.new(long_key, crypto: 'aes-256-cbc')

# Ruby 2.4+ where OpenSSL requires correct length secret keys:
long_key = '23rwfnlknf8923nfaelrjnf23nfaewrinflaekrn932fiueranljkgniu3n4fkeuya'
proper_key = long_key[0, 32]
ActiveSupport::MessageEncryptor.new(proper_key, long_key, crypto: 'aes-256-cbc')
```

I hope this helps someone out there who's pulling their hair out because can't
decrypt stuff once upgrading to Ruby 2.4+.
