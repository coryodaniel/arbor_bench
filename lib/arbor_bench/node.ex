defmodule ArborBench.Node do
  use Ecto.Schema
  use Arbor.Tree

  schema "nodes" do
    belongs_to :parent, ArborBench.Node
  end
end
