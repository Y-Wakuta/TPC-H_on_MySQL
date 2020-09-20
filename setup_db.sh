#!/bin/bash

cd /tpch-patches/src/tpc-h-tool/dbgen
mysql -uroot -proot -D sf1 < dss.ddl
mysql -uroot -proot -D sf1 -e "SET GLOBAL local_infile=on;"
for tbl_file in $(find . -name "*.tbl"); do mysql -uroot -proot --local-infile=1 -D sf1 -e "LOAD DATA LOCAL INFILE '$tbl_file' INTO TABLE $(basename $tbl_file .tbl) FIELDS TERMINATED by '|' LINES TERMINATED BY '\n';"; done
