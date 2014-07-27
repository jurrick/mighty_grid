# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.

Dummy::Application.config.secret_key_base = '5c3c6e273e49a6e56fa2f13bc8df29e4f3f19f913a5dedff4450741c60dad8385d9ae0fa2cc6eba60048039ac8ddbe34d5d87dfe93c35f3932194d44c35327bc'

# For Rails 3.2
Dummy::Application.config.secret_token = '5c3c6e273e49a6e56fa2f13bc8df29e4f3f19f913a5dedff4450741c60dad8385d9ae0fa2cc6eba60048039ac8ddbe34d5d87dfe93c35f3932194d44c35327bc'
