defmodule ArborBench.Migrations.CreateNodes do
  use Ecto.Migration

  def change do
    create table(:nodes) do
      add :parent_id, references(:nodes), null: true
    end
    create index(:nodes, [:parent_id, :id])
  end
end
