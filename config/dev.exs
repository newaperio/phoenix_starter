import Config

# Configure your database
config :phoenix_starter, PhoenixStarter.Repo,
  database: "phoenix_starter_dev",
  hostname: "localhost",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

web_port = 4000

# For development, we disable any cache and enable
# debugging and code reloading.
config :phoenix_starter, PhoenixStarterWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: web_port],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  secret_key_base: "7nP1poUpni9iUuIk8xM3pAmbRgwYGZjBfUdh5NgjRX92w/20ndnn7s6x69rFzBxB",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ]

# Watch static and templates for browser reloading.
config :phoenix_starter, PhoenixStarterWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/phoenix_starter_web/(live|views)/.*(ex)$",
      ~r"lib/phoenix_starter_web/templates/.*(heex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Configures Sentry
config :sentry, environment_name: "dev"

# Config Content Security Policy
config :phoenix_starter, PhoenixStarterWeb.ContentSecurityPolicy,
  allow_unsafe: true,
  app_host: "localhost:#{web_port}"
