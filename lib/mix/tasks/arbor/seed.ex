defmodule Mix.Tasks.Arbor.Seed do
  use Mix.Task
  import Mix.Ecto

  alias ArborBench.{Node, Repo}

  def run(args) do
    start_repos(args)
    usage
    switches = [max: :integer, pct_root: :integer]
    aliases  = [m: :max, p: :pct_root]

    {opts, _, _} = OptionParser.parse(args,
                                      strict: switches,
                                      aliases: aliases)
    opts = Keyword.merge(defaults, opts)

    # Truncate to get the SERIALs reset, this will make it easier to build
    # child nodes, because we can guarantee IDs to randomly pick w/o doing a
    # SQL SELECT.
    Ecto.Adapters.SQL.query(Repo, "TRUNCATE TABLE nodes RESTART IDENTITY")

    num_roots = div(opts[:max], div(100, opts[:pct_root]))
    num_leafs = opts[:max] - num_roots
    max_root_id = num_roots
    pg_max_params = 65535

    IO.puts "Building root nodes ..."
    roots = Enum.map 1..num_roots, fn(_) -> %{} end
    roots
    |> Enum.chunk(pg_max_params, pg_max_params, [])
    |> Enum.map(fn(batch) ->
      IO.puts "Batch: #{length(batch)} root nodes"
      Repo.insert_all Node, batch
    end)

    IO.puts "Building leaf nodes ..."
    leafs = Enum.map 1..num_leafs, fn(n) ->
      max_parent_id = max_root_id + (n - 1)
      parent_id = :rand.uniform(max_parent_id)
      create_child_of parent_id
    end

    leafs
    |> Enum.chunk(pg_max_params, pg_max_params, [])
    |> Enum.map(fn(batch) ->
      IO.puts "Batch: #{length(batch)} leaf nodes"
      Repo.insert_all Node, batch
    end)
  end

  def defaults do
    [
      max: 1_000_000,
      pct_root: 25
    ]
  end

  def usage do
    IO.puts "Usage:\n\tmix arbor.seed -m MAX_NODES -p PCT_ROOT"
  end

  def create_child_of(parent_id) do
    %{parent_id: parent_id}
  end

  def start_repos(args) do
    repos = parse_repo(args)
    Enum.each repos, fn repo ->
      ensure_repo(repo, args)
      ensure_started(repo, args)
    end
  end
end
