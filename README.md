# lita-facebook-messenger

Lita adapter for [Facebook Messenger Platform](https://messengerplatform.fb.com). See the link for setup instructions.

## Installation

Add lita-facebook-messenger to your Lita instance's Gemfile:

``` ruby
gem "lita-facebook-messenger", github: 'wasi/lita-facebook-messenger'
```

## Configuration

### lita_config.rb

```ruby
config.robot.adapter = :facebook-messenger

config.adapters.facebook_messenger.facebook_access_token = ENV['FACEBOOK_TOKEN']
config.adapters.facebook_messenger.facebook_app_secret = ENV['FACEBOOK_SECRET']
config.adapters.facebook_messenger.facebook_verify_token = ENV['FACEBOOK_VERIFY_TOKEN']
```

## TODO

* Tests
