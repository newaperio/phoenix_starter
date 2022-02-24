import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
config :phoenix_starter, PhoenixStarter.Repo,
  database: "phoenix_starter_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_starter, PhoenixStarterWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configures Swoosh
config :phoenix_starter, PhoenixStarter.Mailer, adapter: Swoosh.Adapters.Test

# Configures Oban
config :phoenix_starter, Oban, crontab: false, queues: false, plugins: false

# Configures Sentry
config :sentry, environment_name: "test"

# Configures ExAWS
config :ex_aws,
  access_key_id: "AKIATEST",
  secret_access_key: "TESTKEY"
