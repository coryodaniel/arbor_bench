-- psql -qAt -f explain.sql --dbname=arbor_bench > analyze.json
EXPLAIN (
  ANALYZE true,
  VERBOSE true,
  COSTS true,
  BUFFERS true, FORMAT JSON
)
WITH RECURSIVE tree AS (
   SELECT id, parent_id, 1 as depth
   FROM nodes
   WHERE id = 9540362

UNION ALL

   SELECT p.id, p.parent_id, t.depth + 1
   FROM nodes p
     JOIN tree t ON t.parent_id = p.id
)
SELECT * FROM tree
