import Config

if config_env() == :prod do
  # Configures Ecto
  with {:ok, database_name} <- System.fetch_env("DATABASE_NAME"),
       {:ok, database_username} <- System.fetch_env("DATABASE_USER"),
       {:ok, database_password} <- System.fetch_env("DATABASE_PASSWORD"),
       {:ok, database_hostname} <- System.fetch_env("DATABASE_HOST") do
    database_hostname =
      if String.contains?(database_hostname, ":") do
        database_hostname |> String.split(":") |> List.first()
      else
        database_hostname
      end

    config :phoenix_starter, PhoenixStarter.Repo,
      database: database_name,
      username: database_username,
      password: database_password,
      hostname: database_hostname,
      pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
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

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  # Configures Phoenix endpoint
  config :phoenix_starter, PhoenixStarterWeb.Endpoint,
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ],
    live_view: [signing_salt: System.fetch_env!("LIVE_VIEW_SALT")],
    secret_key_base: secret_key_base,
    url: [scheme: "https", host: System.get_env("APP_HOST"), port: 443]

  # Configures libcluster
  if cluster_service_discovery_dns_query = System.get_env("SERVICE_DISCOVERY") do
    config :phoenix_starter, PhoenixStarter.ClusterSupervisor,
      aws_service_discovery_private_dns_namespace: [
        strategy: Cluster.Strategy.DNSPoll,
        config: [
          polling_interval: 5_000,
          query: cluster_service_discovery_dns_query,
          node_basename: System.fetch_env!("APP_NAME")
        ]
      ]
  end

  # Configures Swoosh
  # Note: by default this reads from the IAM task or instance role
  config :phoenix_starter, PhoenixStarter.Mailer, adapter: Swoosh.Adapters.AmazonSES

  # Configures Sentry
  config :sentry,
    dsn: System.get_env("SENTRY_DSN"),
    environment_name: System.get_env("SENTRY_ENV", Atom.to_string(config_env()))

  # Configures Uploads
  config :phoenix_starter, PhoenixStarter.Uploads, bucket_name: System.get_env("AWS_S3_BUCKET")

  # Config Content Security Policy
  config :phoenix_starter, PhoenixStarterWeb.ContentSecurityPolicy,
    app_host: System.get_env("APP_HOST")
end

if config_env() == :test && System.get_env("CI") == "true" do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :phoenix_starter, PhoenixStarter.Repo, url: database_url
end
