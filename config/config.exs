# General application configuration
import Config

config :phoenix_starter,
  ecto_repos: [PhoenixStarter.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :phoenix_starter, PhoenixStarterWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: PhoenixStarterWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PhoenixStarter.PubSub,
  live_view: [signing_salt: "uqk1W4Ui"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :phoenix_starter, PhoenixStarter.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

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

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.51",
  default: [
    args:
      ~w(js/app.ts --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Tailwind CSS
config :tailwind,
  version: "3.1.6",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
