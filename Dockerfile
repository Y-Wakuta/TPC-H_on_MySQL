FROM mysql:8.0.21

RUN apt-get update
RUN apt-get install -y unzip

COPY ./validate_join.sh ./
COPY ./tpch_sf_1.sql.zip ./
RUN unzip ./tpch_sf_1.sql.zip
