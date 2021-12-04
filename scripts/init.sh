#!/bin/bash -x

PROJECT_DIR=..

cd `dirname $0`

# init environment variables
cp -v ${PROJECT_DIR}/.env.example ${PROJECT_DIR}/.env

# init mysql log files
mkdir -p ${PROJECT_DIR}/log/mysql
touch ${PROJECT_DIR}/log/mysql/mysqld.log

# init log file permission
find ${PROJECT_DIR}/log -type f -print | xargs chmod 666
