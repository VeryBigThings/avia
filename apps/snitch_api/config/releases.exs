import Config

config :snitch_api, SnitchApiWeb.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  session_cookie_name: System.get_env("SESSION_COOKIE_NAME"),
  session_cookie_signing_salt: System.get_env("SESSION_COOKIE_SIGNING_SALT"),
  session_cookie_encryption_salt: System.get_env("SESSION_COOKIE_ENCRYPTION_SALT")
