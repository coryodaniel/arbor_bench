-- psql -qAt -f explain.sql --dbname=arbor_bench > analyze.json
EXPLAIN (
  ANALYZE true,
  VERBOSE true,
  COSTS true,
  BUFFERS true, FORMAT JSON
)
SELECT n0."id", n0."parent_id" FROM "nodes" AS n0 INNER JOIN (
  WITH RECURSIVE nodes_tree AS (
    SELECT id,
           0 AS depth
    FROM nodes
    WHERE parent_id = 8330306::integer
  UNION ALL
    SELECT nodes.id,
           nodes_tree.depth + 1
    FROM nodes
      JOIN nodes_tree
      ON nodes.parent_id = nodes_tree.id
  )
  SELECT * FROM nodes_tree
) AS f1 ON n0."id" = f1."id"
