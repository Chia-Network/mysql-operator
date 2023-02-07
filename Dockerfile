ARG BASE_VERSION=8.0.32-2.0.8
FROM mysql/mysql-operator:$BASE_VERSION
COPY mysqloperator/ /usr/lib/mysqlsh/python-packages/
