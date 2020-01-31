defmodule JOE.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      JOEWeb.Endpoint
      # Starts a worker by calling: JOE.Worker.start_link(arg)
      # {JOE.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: JOE.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    JOEWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # Our state is not changing. Load here.
  @state fn ->
    state =
      JOE.professions_file(Mix.env())
      |> JOE.read_professions_file!()
      |> Enum.reduce(nil, & JOE.receive(&2, &1))

    state =
      JOE.offers_file(Mix.env())
      |> JOE.read_offers_file!()
      |> Enum.reduce(state, & JOE.receive(&2, &1))

    state
  end.()

  def get_state(), do: @state
end
