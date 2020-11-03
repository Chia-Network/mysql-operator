# Copyright (c) 2020, Oracle and/or its affiliates.

registry=$1
version=$2

if [ -z "$registry" ]; then
    registry=local
fi
if [ -z "$version" ]; then
    version=8.0.21
fi

image=$registry/mysql-shell:$version


if [ -n "$clean" -o ! -d bld.mysql-shell ]; then
    rm -fr bld.mysql-shell
    mkdir bld.mysql-shell
    cd bld.mysql-shell
else
    cd bld.mysql-shell
fi

cp ../mysql-shell/Dockerfile .

# Copy mysqlsh binary
mkdir -p usr
(cd ../../../../bld-vagrant/usr/local; tar cf - *) | (cd usr; tar xf -)
# Copy operator code
(cd ../../../../bld; ninja)
cp -r ../../mysqloperator usr/lib/mysqlsh/python-packages/

if [ ! -d usr/lib/mysqlsh/lib/python3.7/site-packages/kopf ]; then
  # Install deps that should come bundled
  pip3 install git+https://github.com/kubernetes-client/python.git@release-11.0 --target=usr/lib/mysqlsh/lib/python3.7/site-packages/
  pip3 install git+https://github.com/nolar/kopf.git@0.28 --target=usr/lib/mysqlsh/lib/python3.7/site-packages/ --no-deps
  # dependencies from kopf that we know are needed
  pip3 install typing_extensions iso8601 python-json-logger "aiohttp<4.0.0" aiojobs "chardet<4.0,>=2.0" "async-timeout<4.0,>=3.0" "yarl<2.0,>=1.0" "attrs>=17.3.0" "multidict<5.0,>=4.5" "requests>=2.12" "idna>=2.0" "certifi>=2017.4.17" "urllib3!=1.25.0,!=1.25.1,<1.26,>=1.21.1" --target=usr/lib/mysqlsh/lib/python3.7/site-packages/ --no-deps
fi

docker build . -t $image
docker tag $image $registry/mysql-shell:latest
