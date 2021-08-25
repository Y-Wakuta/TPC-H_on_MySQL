-- these indexes are added for faster join queries.
-- Since these indexes are not TPC-H original, the database cannot be benchmarked as TPC-H

CREATE INDEX l_orderkey_hash_index on lineitem(l_orderkey) using hash;
CREATE INDEX l_partkey_hash_index on lineitem(l_partkey) using hash;
CREATE INDEX l_suppkey_hash_index on lineitem(l_suppkey) using hash;
CREATE INDEX ps_partkey_hash_index on partsupp(ps_partkey) using hash;
CREATE INDEX ps_suppkey_hash_index on partsupp(ps_suppkey) using hash;


-- indexes for duplicated tables
CREATE INDEX l_orderkey_dup_hash_index on lineitem_dup(l_orderkey) using hash;
CREATE INDEX l_partkey_dup_hash_index on lineitem_dup(l_partkey) using hash;
CREATE INDEX l_suppkey_dup_hash_index on lineitem_dup(l_suppkey) using hash;
ALTER TABLE tpch.lineitem_dup ADD FOREIGN KEY LINEITEM_DUP_FK2 (L_PARTKEY,L_SUPPKEY) references tpch.partsupp (PS_PARTKEY, PS_SUPPKEY) ON DELETE CASCADE;
-- ALTER TABLE tpch.lineitem_dup ADD FOREIGN KEY LINEITEM_DUP_FK1 (L_ORDERKEY)  references tpch.orders (O_ORDERKEY) ON DELETE CASCADE;
ALTER TABLE tpch.lineitem_dup ADD FOREIGN KEY LINEITEM_DUP_FK1 (L_ORDERKEY)  references tpch.orders_dup (O_ORDERKEY) ON DELETE CASCADE;
CREATE INDEX o_orderkey_dup_hash_index on orders_dup(o_orderkey) using hash;
ALTER TABLE tpch.orders_dup ADD FOREIGN KEY ORDERS_DUP_FK1 (O_CUSTKEY)  references tpch.customer_dup (C_CUSTKEY) ON DELETE CASCADE;
CREATE INDEX c_custkey_dup_hash_index on customer_dup(c_custkey) using hash;
ALTER TABLE tpch.customer_dup ADD FOREIGN KEY CUSTOMER_DUP_FK1 (C_NATIONKEY) references tpch.nation (N_NATIONKEY) ON DELETE CASCADE;

