defmodule ContainerApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    {:ok, port} = Confex.fetch_env(:container_api, :api_port)
    IO.inspect(port)
    children = [
      Plug.Cowboy.child_spec(scheme: :http, plug: ContainerApi.Router, options: [port: port])
    ]
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ContainerApi.Supervisor]
    IO.puts("Server started on port #{port}")
    Supervisor.start_link(children, opts)
  end
end
