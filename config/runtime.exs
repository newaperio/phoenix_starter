import Config

database_url = System.get_env("DATABASE_URL")

if config_env() == :prod do
  {:ok, ssm_resp} =
    "/staging/phoenix-starter/database/url"
    |> ExAws.SSM.get_parameter(with_decryption: true)
    |> ExAws.request()

  database_url = ssm_resp["Parameter"]["Value"]

  if database_url == nil do
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """
  end

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :phoenix_starter, PhoenixStarterWeb.Endpoint,
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ],
    live_view: [signing_salt: System.get_env("LIVE_VIEW_SALT")],
    secret_key_base: secret_key_base,
    url: [scheme: "https", host: System.get_env("APP_HOST"), port: 443]

  # Configures Bamboo
  # Note: by default this reads from the IAM task or instance role
  config :phoenix_starter, PhoenixStarter.Mailer, adapter: Bamboo.SesAdapter

  # Configures Sentry
  config :sentry,
    dsn: System.fetch_env!("SENTRY_DSN"),
    environment_name: System.fetch_env!("SENTRY_ENVIRONMENT")
end

if database_url != nil do
  config :phoenix_starter, PhoenixStarter.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
end
