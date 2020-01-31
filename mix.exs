defmodule JOE.MixProject do
  use Mix.Project

  def project do
    [
      app: :joe,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {JOE.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:nimble_csv, "~> 0.6"},
      {:table_rex, "~> 2.0.0"},
      {:geo, "~> 3.0"},
      {:topo, "~> 0.4.0"},
      {:geocalc, "~> 0.5"},
      {:jason, "~> 1.1"},
      {:phoenix, "~> 1.4.12"},
      {:phoenix_pubsub, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
end
