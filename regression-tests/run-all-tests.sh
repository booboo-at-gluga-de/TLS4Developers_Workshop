#!/bin/bash

if [[ "$1" = "-s" ]]; then
    REPORT_FORMAT=""
else
    REPORT_FORMAT="--format documentation"
fi

goss --gossfile=/vagrant/regression-tests/goss-checks/goss.yaml validate $REPORT_FORMAT
