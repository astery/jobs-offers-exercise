defmodule JOE.MixProject do
  use Mix.Project

  def project do
    [
      app: :joe,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nimble_csv, "~> 0.6"},
      {:table_rex, "~> 2.0.0"},
    ]
  end
end
