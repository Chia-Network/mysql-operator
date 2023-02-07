ARG BASE_VERSION=8.0.32-2.0.8
FROM mysql/mysql-operator:$BASE_VERSION

COPY mysqloperator/init_main.py /usr/lib/mysqlsh/python-packages/mysqloperator/
COPY mysqloperator/controller/innodbcluster/cluster_api.py /usr/lib/mysqlsh/python-packages/mysqloperator/controller/innodbcluster/
COPY mysqloperator/controller/innodbcluster/router_objects.py /usr/lib/mysqlsh/python-packages/mysqloperator/controller/innodbcluster/
