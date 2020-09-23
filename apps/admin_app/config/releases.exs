import Config

config :admin_app, AdminAppWeb.Endpoint,
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
  session_cookie_name: System.fetch_env!("SESSION_COOKIE_NAME"),
  session_cookie_signing_salt: System.fetch_env!("SESSION_COOKIE_SIGNING_SALT"),
  session_cookie_encryption_salt: System.fetch_env!("SESSION_COOKIE_ENCRYPTION_SALT")
