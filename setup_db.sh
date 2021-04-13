#!/bin/bash

echo $dump_file

function setup_dbgen(){
    cd /tpch-patches/src/tpc-h-tool/dbgen
    mysql -uroot -proot -D tpch < /tpch-patches/src/tpc-h-tool/dbgen/dss.ddl
    mysql -uroot -proot -D tpch -e "SET GLOBAL local_infile=on;"

    mysql -uroot -proot -D tpch -e "ALTER TABLE orders ADD dummy integer;"
    mysql -uroot -proot -D tpch -e "ALTER TABLE orders ALTER dummy SET DEFAULT 0;"
    mysql -uroot -proot -D tpch -e "ALTER TABLE lineitem ADD dummy integer;"
    mysql -uroot -proot -D tpch -e "ALTER TABLE lineitem ALTER dummy SET DEFAULT 0;"

    mysql -uroot -proot -D tpch -e "SET GLOBAL wait_timeout=86400;"
    mysql -uroot -proot -D tpch -e "SET GLOBAL max_allowed_packet=1 * 1024 * 1024;"

    echo "loading data"
    for tbl_file in *.tbl; do mysql -uroot -proot --local-infile=1 -D tpch -e "LOAD DATA LOCAL INFILE '$tbl_file' INTO TABLE $(basename $tbl_file .tbl) FIELDS TERMINATED by '|' LINES TERMINATED BY '\n';"; done

    echo "creating index"
    mysql -uroot -proot -D tpch < dss.ri

    echo "creating additional index"
    mysql -uroot -proot -D tpch < additional_indexes.sql
}

# disable some MySQL features for faster loading
mysql -uroot -proot -D tpch -e "SET GLOBAL innodb_flush_log_at_trx_commit = 0;"
mysql -uroot -proot -D tpch -e "SET GLOBAL FOREIGN_KEY_CHECKS=0;"

time setup_dbgen

# re-enable MySQL features for consistency
mysql -uroot -proot -D tpch -e "SET GLOBAL innodb_flush_log_at_trx_commit = 1;"
mysql -uroot -proot -D tpch -e "SET GLOBAL FOREIGN_KEY_CHECKS=1;"

# copy value from lineitem.l_orderkey to lineitem.l_linenumber
mysql -uroot -proot -D tpch -e "SET @rank:=10;UPDATE lineitem SET l_linenumber=@rank:=@rank+1;"

for tbl_file in *.tbl; do mysql -uroot -proot -D tpch -e "SELECT COUNT(*) FROM $(basename $tbl_file .tbl);"; done

echo "validate joins"
./validate_join.sh

echo "process done"

