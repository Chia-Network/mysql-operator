ARG BASE_VERSION=8.0.32-2.0.8
FROM mysql/mysql-operator:$BASE_VERSION

USER 0

RUN rm -rf /usr/lib/mysqlsh/python-packages/mysqloperator/
COPY mysqloperator /usr/lib/mysqlsh/python-packages/

USER 2
