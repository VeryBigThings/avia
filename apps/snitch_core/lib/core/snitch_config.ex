defmodule SnitchConfig do
  use Provider,
    source: Provider.SystemEnv,
    params: [
      {:database_url, dev: dev_db_url()},
      {:host, dev: "localhost"},
      {:db_pool_size, type: :integer, default: 10},
      {:secret_key_base, dev: "37wHSGAcjwRm+e+Bwoc2LBze2IdDvzcGDMrFxR0JYxQKSCwILSS37UbY592OfKXv"},
      {:app_url, dev: "http://localhost:3449"},
      {:sendgrid_api_key, dev: "sg.api.key"},
      {:port, type: :integer, default: 4000},
      {:asset_bucket, dev: "asset_bucket"},
      {:aws_region, dev: "us-east-1"},
      {:aws_role_arn, dev: "generated"},
      {:aws_web_identity_token_file, dev: "generated"},
      {:solaborate_url, dev: "https://staging.banyansolaborate.com"}
    ]

  if Mix.env() in ~w/dev test/a do
    defp dev_db_url do
      db_host = System.get_env("PGHOST", "localhost")
      db_name = if ci?(), do: "banmed_test", else: "banmed_#{unquote(Mix.env())}"
      "postgresql://postgres:postgres@#{db_host}/#{db_name}"
    end

    defp ci?, do: System.get_env("CI") == "true"
  end
end
