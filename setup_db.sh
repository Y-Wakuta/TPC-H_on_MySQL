#!/bin/bash

cd /tpch-patches/src/tpc-h-tool/dbgen
mysql -uroot -proot -D tpch < /tpch-patches/src/tpc-h-tool/dbgen/dss.ddl
mysql -uroot -proot -D tpch -e "SET GLOBAL local_infile=on;"

mysql -uroot -proot -D tpch -e "ALTER TABLE orders ADD dummy integer;"
mysql -uroot -proot -D tpch -e "ALTER TABLE orders ALTER dummy SET DEFAULT 0;"
mysql -uroot -proot -D tpch -e "ALTER TABLE lineitem ADD dummy integer;"
mysql -uroot -proot -D tpch -e "ALTER TABLE lineitem ALTER dummy SET DEFAULT 0;"

mysql -uroot -proot -D tpch -e "SET GLOBAL wait_timeout=86400;"
#mysql -uroot -proot -D tpch -e "SET GLOBAL innodb_buffer_pool_size=1 * 1024 * 1024;"
mysql -uroot -proot -D tpch -e "SET GLOBAL max_allowed_packet=1 * 1024 * 1024;"

echo "loading data"
for tbl_file in *.tbl; do mysql -uroot -proot --local-infile=1 -D tpch -e "LOAD DATA LOCAL INFILE '$tbl_file' INTO TABLE $(basename $tbl_file .tbl) FIELDS TERMINATED by '|' LINES TERMINATED BY '\n';"; done

for tbl_file in *.tbl; do mysql -uroot -proot -D tpch -e "SELECT COUNT(*) FROM $(basename $tbl_file .tbl);"; done

echo "creating index"
mysql -uroot -proot -D tpch < dss.ri

echo "miniaturilizing demension tables for debug"
./miniaturize_db.sh

# copy value from lineitem.l_orderkey to lineitem.l_linenumber
mysql -uroot -proot -D tpch -e "SET @rank:=10;UPDATE lineitem SET l_linenumber=@rank:=@rank+1;"


for tbl_file in *.tbl; do mysql -uroot -proot -D tpch -e "SELECT COUNT(*) FROM $(basename $tbl_file .tbl);"; done

echo "validate joins"
./validate_join.sh

echo "process done"
