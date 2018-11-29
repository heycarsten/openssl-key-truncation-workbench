# OpenSSL Key Truncation Investigation

In Ruby > 2.3 openssl rejects keys larger than the requested cypher allows,
this means keys that were working no longer do, what needs to be done to a key
so that it works again? Is it even possible?

## Using

1. You'll need to install [RVM](https://rvm.io)
2. `bundle`
3. `script/run-tests`
