defmodule PhoenixStarter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PhoenixStarter.Repo,
      # Start the Telemetry supervisor
      PhoenixStarterWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PhoenixStarter.PubSub},
      # Start the Endpoint (http/https)
      PhoenixStarterWeb.Endpoint
      # Start a worker by calling: PhoenixStarter.Worker.start_link(arg)
      # {PhoenixStarter.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixStarter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PhoenixStarterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
