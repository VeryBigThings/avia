import Config

config :snitch_api, frontend_checkout_url: System.fetch_env!("FRONTEND_CHECKOUT_URL")

config :snitch_api, hosted_payment_url: System.fetch_env!("HOSTED_PAYMENT_URL")
