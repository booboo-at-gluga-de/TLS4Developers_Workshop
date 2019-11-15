#!/bin/bash

# 2019-09-18 booboo
# this script will prepare the configuration of the CA used in this example
# therefor it will create a directory "ca" in the current directory
# or some other directory given as first commandline parameter
# and create some configs there

if [[ -d "$1" ]]; then
    WORKING_DIR=$1
else
    WORKING_DIR=$(readlink -f $(pwd))
    declare -u ANSWER

    echo
    echo "Will create a new directory \"ca\" here (in $WORKING_DIR)."
    echo -n "Do you want to continue? "
    read ANSWER

    if [[ "$ANSWER" != "Y" ]] && [[ "$ANSWER" != "YES" ]]; then
        echo
        echo ABORTING!!
        echo You might want to change to your preferred working directory and start the script again!
        echo
        exit 1
    fi
fi
SCRIPT_DIR=$(readlink -f $(dirname $0))

touch ~/.rnd
mkdir $WORKING_DIR/ca || exit 1
mkdir $WORKING_DIR/ca/newcerts || exit 1
mkdir $WORKING_DIR/ca/private || exit 1
chmod 700 $WORKING_DIR/ca/private || exit 1
echo -ne "01" >$WORKING_DIR/ca/serial || exit 1
echo -ne "01" >$WORKING_DIR/ca/crlnumber || exit 1
touch $WORKING_DIR/ca/index.txt || exit 1
touch $WORKING_DIR/ca/index.txt.attr || exit 1
cp $SCRIPT_DIR/openssl/ca.cnf $WORKING_DIR/ca/ || exit 1
sed -i -e "s#/home/vagrant#${WORKING_DIR}#" $WORKING_DIR/ca/ca.cnf || exit 1
cp $SCRIPT_DIR/openssl/openssl.cnf $WORKING_DIR/ || exit 1
sed -i -e "s#/home/vagrant#${WORKING_DIR}#" $WORKING_DIR/openssl.cnf || exit 1

echo
echo OK, created directory \"ca\" for you with following content:
echo ==========================================================
ls -l $WORKING_DIR/ca/
