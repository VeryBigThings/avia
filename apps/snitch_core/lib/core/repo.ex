defmodule Snitch.Repo do
  use Ecto.Repo,
    otp_app: :snitch_core,
    adapter: Ecto.Adapters.Postgres

  if Mix.env() == :test do
    def init(_type, config),
      do: {:ok, Keyword.put(config, :url, System.fetch_env!("TEST_DB_URL"))}
  else
    def init(_type, config), do: {:ok, Keyword.put(config, :url, System.fetch_env!("DB_URL"))}
  end
end
