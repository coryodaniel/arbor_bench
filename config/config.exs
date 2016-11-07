# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :arbor_bench, ecto_repos: [ArborBench.Repo]

config :arbor_bench, ArborBench.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool_size: 30,
  database: "arbor_bench",
  username: "postgres",
  password: "",
  hostname: "localhost"

config :logger, level: :info
