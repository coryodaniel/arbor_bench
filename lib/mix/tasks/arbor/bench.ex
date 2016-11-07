defmodule Mix.Tasks.Arbor.Bench do
  use Mix.Task
  import Mix.Ecto
  import Ecto.Query

  alias ArborBench.{Node, Repo}

  def run(args) do
    start_repos(args)
    usage
    {opts, _, _} = OptionParser.parse(args,
                                      strict: [func: :string, runs: :integer, nodes: :integer])

    opts = Keyword.merge(defaults, opts)

    query = from(
      n in Node,
      where: not is_nil(n.parent_id),
      limit: ^opts[:nodes],
      order_by: fragment("RANDOM()")
    )

    runs = opts[:runs]
    nodes = Repo.all(query)

    #IO.inspect bench_ancestors(nodes, runs)
    opts[:func]
    |> String.split(",")
    |> Enum.each(fn(func) ->
      IO.puts "Running #{func}"
      times = bench(nodes, runs, func)
      total = Enum.sum(times)
      IO.puts "\t#{runs} runs"
      IO.puts "\tTotal time: #{total}"
      IO.puts "\tAvg: #{total/runs}"
    end)
  end

  def bench(nodes, runs, func) do
    nodes
    |> Stream.cycle
    |> Stream.map(fn(node) ->
      :erlang.apply(Node, String.to_atom(func), [node])
    end)
    |> Enum.take(runs)
    |> Enum.map(fn(query) ->
      t = time(fn -> Repo.all(query) end)
      IO.puts t
      t
    end)
  end

  defp usage do
    IO.puts "Usage:\n\tmix arbor.bench --func=siblings,children,descendants,ancestors --runs=NUM_QUERIES_TO_RUN --nodes=NUM_NODES_AS_TEST_SUBJECT"
  end

  def time(func) do
    func
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
  end

  def defaults do
    [runs: 1_000, nodes: 10, func: "siblings,children,descendants,ancestors"]
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end

  def start_repos(args) do
    repos = parse_repo(args)
    Enum.each repos, fn repo ->
      ensure_repo(repo, args)
      ensure_started(repo, args)
    end
  end
end
