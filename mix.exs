defmodule PhoenixStarter.MixProject do
  use Mix.Project

  def project do
    [
      app: :phoenix_starter,
      version: "0.1.0",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
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
      {:bamboo, "~> 1.6"},
      {:bamboo_ses, "~> 0.1.0"},
      {:bcrypt_elixir, "~> 2.0"},
      {:credo, "~> 1.5.0-rc.2", only: [:dev, :test], runtime: false},
      {:ecto_psql_extras, "~> 0.2"},
      {:ecto_sql, "~> 3.4"},
      {:ex_aws, "~> 2.0"},
      {:ex_aws_ssm, "~> 2.0"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:floki, ">= 0.27.0", only: :test},
      {:gettext, "~> 0.11"},
      {:hackney, "~> 1.8"},
      {:jason, "~> 1.0"},
      {:libcluster, "~> 3.2"},
      {:oban, "~> 2.1"},
      {:phoenix, "~> 1.5.6"},
      {:phoenix_ecto, "~> 4.1"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_dashboard, "~> 0.3 or ~> 0.2.9"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.14.6"},
      {:phx_gen_auth, "~> 0.5", only: [:dev], runtime: false},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:sentry, "8.0.4"},
      {:sobelow, "~> 0.10", only: [:dev, :test]},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"}
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
