import Config

# Configure your database
config :snitch_core, Snitch.Repo, pool_size: 10

config :snitch_core, :defaults_module, Snitch.Tools.Defaults
config :arc, storage: Arc.Storage.Local
config :snitch_core, :user_config_module, Snitch.Tools.UserConfig

# TODO: Remove this hack when we set up the config system
config :snitch_core, :defaults, currency: :USD
