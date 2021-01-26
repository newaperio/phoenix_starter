# General application configuration
import Config

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

# Configures Bamboo
# Note: by default this reads from the IAM task or instance role
config :phoenix_starter, PhoenixStarter.Email,
  default_from: {"PhoenixStarter", "notifications@example.com"}

# Configures Oban
config :phoenix_starter, Oban,
  repo: PhoenixStarter.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10, emails: 10]

# Configures Sentry
config :sentry,
  enable_source_code_context: true,
  included_environments: ~w(prod stage),
  release: Mix.Project.config()[:version],
  root_source_code_path: File.cwd!()

# Configures ExAWS
# Note: by default this reads credentials from ENV vars then task role
config :ex_aws,
  region: "us-east-1"

# Configures Uploads
config :phoenix_starter, PhoenixStarter.Uploads,
  bucket_name: "#{config_env()}-phoenix-starter-uploads"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
