#!/bin/bash

#
# a simple way to parse shell script arguments
#
# please edit and use to your hearts content
#


ENVIRONMENT="dev"
DB_PATH="/data/db"

function usage()
{
    echo "if this was a real script you would see something useful here"
    echo ""
    echo "Usage: ./simple_args_parsing.sh [--environment=] [--db-path=]"
    echo "  -h --help"
    echo "  --environment=$ENVIRONMENT"
    echo "  --db-path=$DB_PATH"
    echo ""
    echo "example:"
    echo "$ ./simple_args_parsing.sh --environment=foo1 --db-path=foo2"
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            return 0
            ;;
        --environment)
            ENVIRONMENT=$VALUE
            ;;
        --db-path)
            DB_PATH=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            return 1
            ;;
    esac
    shift
done


echo "ENVIRONMENT is $ENVIRONMENT";
echo "DB_PATH is $DB_PATH";
