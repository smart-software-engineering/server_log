defmodule ServerLog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ServerLogWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:server_log, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ServerLog.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ServerLog.Finch},
      # Start a worker by calling: ServerLog.Worker.start_link(arg)
      # {ServerLog.Worker, arg},
      # Start to serve requests, typically the last entry
      ServerLogWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ServerLog.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ServerLogWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
