# General application configuration
use Mix.Config

config :phoenix_starter,
  ecto_repos: [PhoenixStarter.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :phoenix_starter, PhoenixStarterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7nP1poUpni9iUuIk8xM3pAmbRgwYGZjBfUdh5NgjRX92w/20ndnn7s6x69rFzBxB",
  render_errors: [view: PhoenixStarterWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PhoenixStarter.PubSub,
  live_view: [signing_salt: "uqk1W4Ui"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
