defmodule PhoenixStarter.MixProject do
  use Mix.Project

  def project do
    [
      app: :phoenix_starter,
      version: "0.1.0",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: dialyzer(),
      default_release: :phoenix_starter,
      releases: releases(),
      name: "PhoenixStarter",
      source_url: "https://github.com/newaperio/phoenix_starter",
      docs: docs()
    ]
  end

  def application do
    [
      mod: {PhoenixStarter.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:assert_identity, "~> 0.1.0", only: :test},
      {:bcrypt_elixir, "~> 2.0"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ecto_psql_extras, "~> 0.2"},
      {:ecto_sql, "~> 3.4"},
      {:ex_aws_s3, "~> 2.1"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:floki, ">= 0.27.0", only: :test},
      {:gen_smtp, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:hackney, "~> 1.8"},
      {:jason, "~> 1.0"},
      {:libcluster, "~> 3.2"},
      {:oban, "~> 2.1"},
      {:phoenix, "~> 1.6"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:phoenix_live_view, "~> 0.17"},
      {:phoenix_swoosh, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:sentry, "8.0.4"},
      {:sobelow, "~> 0.10", only: [:dev, :test]},
      {:swoosh, "~> 1.6"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:timex, "~> 3.6"}
    ]
  end

  defp dialyzer do
    [
      ignore_warnings: ".dialyzer_ignore.exs",
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp releases do
    [
      phoenix_starter: [
        applications: [phoenix_starter: :permanent],
        include_executables_for: [:unix],
        version: {:from_app, :phoenix_starter}
      ]
    ]
  end

  defp docs do
    [
      main: "readme",
      formatters: ["html"],
      extras: ["README.md"],
      groups_for_modules: [
        Core: ~r/PhoenixStarter(\.{0}|\.{1}.*)$/,
        Web: ~r/PhoenixStarterWeb(\.{0}|\.{1}.*)$/
      ],
      nest_modules_by_prefix: [
        PhoenixStarter,
        PhoenixStarterWeb
      ]
    ]
  end
end
