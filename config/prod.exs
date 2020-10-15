import Config

config :phoenix_starter, PhoenixStarter.Repo,
  ssl: true,
  start_apps_before_migration: [:ssl]

config :phoenix_starter, PhoenixStarterWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  force_ssl: [hsts: true, rewrite_on: [:x_forwarded_proto]],
  server: true

# Do not print debug messages in production
config :logger, level: :info, backends: [:console, Sentry.LoggerBackend]

# Configures Sentry
config :sentry, environment_name: "prod"
