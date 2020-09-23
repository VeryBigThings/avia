import Config

# import_config "prod.secret.exs"

config :snitch_core, :defaults_module, Snitch.Tools.Defaults
config :snitch_core, :user_config_module, Snitch.Tools.UserConfig
config :arc, storage: Arc.Storage.S3

config :ex_aws,
  debug_requests: true,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  s3: [region: "eu-west-2"]

# Change SSL settings after testing locally !!!
config :snitch_core, Snitch.Repo, ssl: false

config :snitch_core, :defaults, currency: :USD
