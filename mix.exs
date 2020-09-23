defmodule Snitch.Mixfile do
  use Mix.Project

  def project do
    [
      version: "0.0.1",
      apps_path: "apps",
      elixir: "~> 1.10.4",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.json": :test, "coveralls.html": :test],
      docs: docs(),
      releases: releases(),
      build_path: System.get_env("BUILD_PATH") || "_build"
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:jason, "~> 1.2"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:excoveralls, "~> 0.13", only: :test},
      {:inch_ex, "~> 2.0", only: [:docs, :dev]}
    ]
  end

  defp docs do
    [
      extras: ~w(README.md),
      main: "readme",
      source_url: "https://github.com/aviabird/snitch",
      groups_for_modules: groups_for_modules()
    ]
  end

  defp groups_for_modules do
    [
      Snitch: ~r/^Snitch.?/,
      SnitchApi: ~r/^SnitchApi.?/,
      SnitchAdmin: ~r/^AdminApp.?/
    ]
  end

  defp releases() do
    [
      nue: [
        include_executables_for: [:unix],
        applications: [snitch_core: :permanent, snitch_api: :permanent, admin_app: :permanent],
        steps: [:assemble, &copy_bin_files/1]
      ]
    ]
  end

  defp copy_bin_files(release) do
    File.cp_r("rel/bin", Path.join(release.path, "bin"))
    release
  end
end
