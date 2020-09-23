import Config

config :snitch_core, Snitch.Repo,
  url: System.fetch_env!("DB_URL"),
  pool_size: String.to_integer(System.fetch_env!("POOL_SIZE"))
