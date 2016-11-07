# ArborBench

Bench testing tool for [Arbor](http://github.com/coryodaniel/arbor).

## Usage

mix db.setup
mix arbor.seed -m MAX_NODES -p PCT_ROOT
mix arbor.bench --func=siblings,children,descendants,ancestors --runs=NUM_QUERIES_TO_RUN --nodes=NUM_NODES_AS_TEST_SUBJECT

Setup the database
mix db.setup

Seed it with 1,000,000 nodes 25% as root nodes
mix arbor.seed -m 1000000 -p 25

Run the descendants function 10,000 times using the same set of 2000 (of 1,000,000) nodes. This is useful to have the same subset when comparing all of the functions
mix arbor.seed --func=descendants --runs=10000 --nodes=2000

mix arbor.seed --func=descendants,siblings,children,ancestors --runs=10000 --nodes=2000

Descendants, siblings and children perform very well (tested up to 15mm rows). Ancestors runs at about 4s / query at 1mm nodes and times out on 15mm nodes...

```
Running siblings
	10000 runs
	Total time: 2.3324530000000046
	Avg: 2.3324530000000046e-4
Running children
	10000 runs
	Total time: 2.1838109999999857
	Avg: 2.1838109999999857e-4
Running descendants
	10000 runs
	Total time: 2.141958000000028
	Avg: 2.1419580000000277e-4
```

## TODO
* [ ] dump out a pgbench config instead of benching from elixir
* [ ] compare to ltree / materialized path
* [ ] compare to closure table?


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `arbor_bench` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:arbor_bench, "~> 0.1.0"}]
    end
    ```

  2. Ensure `arbor_bench` is started before your application:

    ```elixir
    def application do
      [applications: [:arbor_bench]]
    end
    ```
