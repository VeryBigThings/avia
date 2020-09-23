import Config

# Configure your database
config :snitch_core, Snitch.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 20

config :snitch_core, :defaults_module, Snitch.Tools.DefaultsMock
config :snitch_core, :user_config_module, Snitch.Tools.UserConfigMock
config :arc, storage: Arc.Storage.Local

config :snitch_core, Snitch.Tools.Mailer, adapter: Bamboo.TestAdapter

config :snitch_core, :defaults, currency: :USD
config :logger, level: :info

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8
