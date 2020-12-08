import Config

if config_env() == :prod do
  # Configures Ecto
  config :phoenix_starter, PhoenixStarter.Repo,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  # if database_url == nil do
  #   raise """
  #   environment variable DATABASE_URL is missing.
  #   For example: ecto://USER:PASS@HOST/DATABASE
  #   """
  # end

  # secret_key_base =
  #   System.get_env("SECRET_KEY_BASE") ||
  #     raise """
  #     environment variable SECRET_KEY_BASE is missing.
  #     You can generate one by calling: mix phx.gen.secret
  #     """

  # config :phoenix_starter, PhoenixStarterWeb.Endpoint,
  #   http: [
  #     port: String.to_integer(System.get_env("PORT") || "4000"),
  #     transport_options: [socket_opts: [:inet6]]
  #   ],
  #   live_view: [signing_salt: System.get_env("LIVE_VIEW_SALT")],
  #   secret_key_base: secret_key_base,
  #   url: [scheme: "https", host: System.get_env("APP_HOST"), port: 443]

  config :phoenix_starter, PhoenixStarterWeb.Endpoint,
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base,
    url: [scheme: "https", port: 443]

  # Configures Bamboo
  # Note: by default this reads from the IAM task or instance role
  config :phoenix_starter, PhoenixStarter.Mailer, adapter: Bamboo.SesAdapter

  # Configures Sentry
  # config :sentry,
  #   dsn: System.fetch_env!("SENTRY_DSN"),
  #   environment_name: System.fetch_env!("SENTRY_ENVIRONMENT")
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
