
miniaturize_table() {
  table=$1
  scale=$2
  echo "== start miniaturize ${table} =="
  old_count=$(mysql -uroot -proot -D tpch -B -N -e "select count(1) from ${table}")
  mysql -uroot -proot -D tpch -e "DELETE FROM ${table} LIMIT $(($old_count - ($old_count / $scale)));"

  count=$(mysql -uroot -proot -D tpch -B -N -e "select count(1) from ${table}")
  echo "done ${table}: from ${old_count} to ${count}"
}


#miniaturize_table nation 5
miniaturize_table supplier 50
miniaturize_table customer 50
miniaturize_table orders 50

#miniaturize_table part 2
#miniaturize_table partsupp 2

miniaturize_table lineitem 50
