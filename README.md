# ArborBench

Bench testing tool for [Arbor](http://github.com/coryodaniel/arbor).

## Usage

```
mix db.setup
mix arbor.seed -m MAX_NODES -p PCT_ROOT
mix arbor.bench --func=siblings,children,descendants,ancestors --runs=NUM_QUERIES_TO_RUN --nodes=NUM_NODES_AS_TEST_SUBJECT
```

Setup the database

`mix db.setup`

Seed it with 1,000,000 nodes 25% as root nodes

`mix arbor.seed -m 1000000 -p 25`

Run the descendants function 10,000 times using the same set of 2000 (of 1,000,000) nodes. This is useful to have the same subset when comparing all of the functions

`mix arbor.seed --func=descendants --runs=10000 --nodes=2000`

`mix arbor.seed --func=descendants,siblings,children,ancestors --runs=10000 --nodes=2000`

Descendants, siblings and children perform very well (tested up to 15mm rows). Ancestors runs at about 4s / query at 1mm nodes and times out on 15mm nodes...

```
Running siblings
    10000 runs
    Total time: 1.793026000000013
    Avg: 1.7930260000000131e-4
Running children
    10000 runs
    Total time: 1.5967949999999786
    Avg: 1.5967949999999787e-4
Running descendants
    10000 runs
    Total time: 2.5418830000000012
    Avg: 2.5418830000000013e-4
Running ancestors
    10000 runs
    Total time: 2.87076499999998
    Avg: 2.87076499999998e-4```
