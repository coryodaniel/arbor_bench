defmodule ArborBench.Mixfile do
  use Mix.Project

  def project do
    [app: :arbor_bench,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     aliases: aliases()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :ecto, :postgrex],
     mod: {ArborBench, []}]
  end

  # mix db.setup, arbor.bench
  def aliases do
    [
      "db.setup": ["ecto.drop", "ecto.create", "ecto.migrate"],
      "bench":    ["arbor.seed", "arbor.bench"]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ecto, ">= 2.0.0"},
      {:postgrex, ">= 0.0.0"},
      {:arbor, "~> 1.0.0"}
    ]
  end
end
