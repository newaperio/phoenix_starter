defmodule PhoenixStarter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    attach_telemetry_handlers()

    children = [
      # Start the Ecto repository
      PhoenixStarter.Repo,
      # Start the Telemetry supervisor
      PhoenixStarterWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PhoenixStarter.PubSub},
      # Start the Endpoint (http/https)
      PhoenixStarterWeb.Endpoint,
      # Start a worker by calling: PhoenixStarter.Worker.start_link(arg)
      # {PhoenixStarter.Worker, arg}
      {Oban, oban_config()},
      {Cluster.Supervisor, [cluster_config(), [name: PhoenixStarter.ClusterSupervisor]]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixStarter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixStarterWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp attach_telemetry_handlers do
    :telemetry.attach_many(
      "oban-errors",
      [[:oban, :job, :exception], [:oban, :circuit, :trip]],
      &PhoenixStarter.Workers.ErrorReporter.handle_event/4,
      %{}
    )
  end

  defp oban_config do
    Application.get_env(:phoenix_starter, Oban)
  end

  defp cluster_config do
    Application.get_env(:phoenix_starter, PhoenixStarter.ClusterSupervisor, [])
  end
end
