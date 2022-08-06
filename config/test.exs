import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
config :phoenix_starter, PhoenixStarter.Repo,
  database: "phoenix_starter_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_starter, PhoenixStarterWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "6/5RwbmC5xd25nqWSKcsgHVAa3GHXJKoRrsInAQgv+8e0f5lRua4vj8K6zpMcmRI",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Configures Swoosh
config :phoenix_starter, PhoenixStarter.Mailer, adapter: Swoosh.Adapters.Test

# Configures Oban
config :phoenix_starter, Oban, testing: :manual

# Configures Sentry
config :sentry, environment_name: "test"

# Configures ExAWS
config :ex_aws,
  access_key_id: "AKIATEST",
  secret_access_key: "TESTKEY"
