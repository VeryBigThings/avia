import Config

config :snitch_core, Snitch.Repo,
  url: System.fetch_env!("DATABASE_URL"),
  pool_size: String.to_integer(System.fetch_env!("POOL_SIZE"))

config :snitch_core, Snitch.Tools.ElasticsearchCluster, url: System.fetch_env!("ELASTIC_HOST")

config :snitch_core, Snitch.BaseUrl,
  frontend_url: System.fetch_env!("FRONTEND_URL"),
  backend_url: System.fetch_env!("BACKEND_URL")

config :snitch_core, Snitch.Tools.Mailer, api_key: System.fetch_env!("SENDGRID_API_KEY")
