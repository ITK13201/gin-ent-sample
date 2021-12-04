#!/bin/bash

MIGRATION_DIR=/app/migrations
DRIVER=mysql

ONE_ARGS_COMMANDS=("up" "up-by-one" "down" "redo" "reset" "status" "version")
TWO_ARGS_COMMANDS=("up-to" "down-to")


if [ $# = 1 ]; then
    flag=0
    for i in "${!ONE_ARGS_COMMANDS[@]}"; do
        if [ "${ONE_ARGS_COMMANDS[$i]}" = "$1" ]; then
            goose -dir $MIGRATION_DIR $DRIVER $DATABASE_DSN $1
            flag=1
        fi
    done
    if [ $flag = 0 ]; then
        echo "invalid command."
        exit 2
    fi
elif [ $# = 2 ]; then
    flag=0
    for i in "${!TWO_ARGS_COMMANDS[@]}"; do
        if [ "${TWO_ARGS_COMMANDS[$i]}" = "$1" ]; then
            goose -dir $MIGRATION_DIR $DRIVER $DATABASE_DSN $1 $2
            flag=1
        fi
    done
    if [ $flag = 0 ]; then
        echo "invalid command."
        exit 2
    fi
else
    echo "invalid command."
    exit 1
fi

exit 0
