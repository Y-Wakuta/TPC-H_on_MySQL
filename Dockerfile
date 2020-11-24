FROM mysql:8.0.21

RUN apt-get update
RUN apt-get install -y git vim unzip build-essential
COPY ./update.patch /
#COPY ./setup_db.sh /docker-entrypoint-initdb.d/
RUN git clone https://github.com/itiut/tpch-patches.git
WORKDIR tpch-patches

RUN mkdir ./src
COPY ./tpc-h-tool.zip ./src/
RUN git apply ../update.patch
RUN PREFIX=/tpch-patches ./install.sh mysql
WORKDIR /tpch-patches/src/tpc-h-tool/dbgen
RUN ./dbgen -s 1
RUN for i in $(seq 1 22); do /tpch-patches/bin/qgen -s 1 $i > $i.sql; done
COPY ./run_queries.sh ./
COPY ./miniaturize_db.sh ./
#COPY ./miniaturize_db_fact.sh ./
COPY ./dss.ddl ./
COPY ./dss.ri ./
COPY ./setup_db.sh ./
COPY ./validate_join.sh ./
