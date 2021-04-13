-- these indexes are added for faster join queries.
-- Since these indexes are not TPC-H original, the database cannot be benchmarked as TPC-H

CREATE INDEX l_orderkey_hash_index on lineitem(l_orderkey) using hash;
CREATE INDEX l_partkey_hash_index on lineitem(l_partkey) using hash;
CREATE INDEX ps_partkey_hash_index on partsupp(ps_partkey) using hash;
CREATE INDEX ps_suppkey_hash_index on partsupp(ps_suppkey) using hash;
