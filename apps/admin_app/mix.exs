defmodule AdminApp.Mixfile do
  use Mix.Project

  def project do
    [
      app: :admin_app,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.10.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {AdminApp.Application, []},
      extra_applications: [:logger, :runtime_tools, :pdf_generator, :sentry, :mnesia]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.4"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_ecto, "~> 4.2"},
      {:plug_cowboy, "~> 2.3"},
      {:gettext, "~> 0.18"},
      {:csv, "~> 2.4"},
      {:elixlsx, "~> 0.4"},
      {:cowboy, "~> 2.8"},
      {:snitch_core, "~> 0.0.1", in_umbrella: true},
      {:guardian, "~> 1.0"},
      {:params, "~> 2.2"},
      {:yaml_elixir, "~> 2.5"},
      # email
      {:swoosh, "~> 1.0.3"},
      {:phoenix_swoosh, "~> 0.3"},
      {:gen_smtp, "~> 0.13"},
      {:snitch_payments, github: "aviacommerce/avia_payments", branch: "develop"},
      {:pdf_generator, "~> 0.6.2"},
      {:jason, "~> 1.1"},

      # import from store
      {:oauther, "~> 1.1"},
      {:honeydew, "~> 1.4"},
      {:sentry, "~> 7.2"},
      {:vbt, git: "git@github.com:VeryBigThings/elixir_common_private"}
    ]
  end
end
