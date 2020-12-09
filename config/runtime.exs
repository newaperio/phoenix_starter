import Config

if config_env() == :prod do
  # Configures Ecto
  config :phoenix_starter, PhoenixStarter.Repo,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  with {:ok, database_name} <- System.fetch_env("DATABASE_NAME"),
       {:ok, database_username} <- System.fetch_env("DATABASE_USER"),
       {:ok, database_password} <- System.fetch_env("DATABASE_PASSWORD"),
       {:ok, database_hostname} <- System.fetch_env("DATABASE_HOST") do
    config :phoenix_starter, PhoenixStarter.Repo,
      database: database_name,
      username: database_username,
      password: database_password,
      hostname: database_hostname
  else
    _ ->
      raise """
      environment variables for database missing.
      Check that all the following are defined:
        - DATABASE_NAME
        - DATABASE_USER
        - DATABASE_PASSWORD
        - DATABASE_HOST
      """
  end

  case System.fetch_env("DATABASE_URL") do
    :error ->
      config :phoenix_starter, PhoenixStarter.Repo,
        database: System.fetch_env!("DATABASE_NAME"),
        username: System.fetch_env!("DATABASE_USER"),
        password: System.fetch_env!("DATABASE_PASSWORD"),
        hostname: System.fetch_env!("DATABASE_HOST")

    {:ok, database_url} ->
      config :phoenix_starter, PhoenixStarter.Repo, url: database_url
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
    live_view: [signing_salt: System.fetch_env!("LIVE_VIEW_SALT")],
    secret_key_base: secret_key_base,
    url: [scheme: "https", host: System.get_env("APP_HOST"), port: 443]

  # Configures Bamboo
  # Note: by default this reads from the IAM task or instance role
  config :phoenix_starter, PhoenixStarter.Mailer, adapter: Bamboo.SesAdapter

  # Configures Sentry
  # config :sentry,
  #   dsn: System.fetch_env!("SENTRY_DSN"),
  #   environment_name: System.fetch_env!("SENTRY_ENVIRONMENT")
end

if config_env() == :test && System.get_env("CI", false) do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :phoenix_starter, PhoenixStarter.Repo, url: database_url
end
