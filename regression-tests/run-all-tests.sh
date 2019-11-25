#!/bin/bash

# you can provide your own domain name (used in the exercises of chapter B)
# by setting (and exporting) the environment variable DOMAIN_NAME_CHAPTER_B
# before starting this script
DOMAIN_NAME_CHAPTER_B=${DOMAIN_NAME_CHAPTER_B:-exercise.jumpingcrab.com}

if [[ "$1" = "-s" ]]; then
    REPORT_FORMAT=""
else
    REPORT_FORMAT="--format documentation"
fi

export DOMAIN_NAME_CHAPTER_B
sudo /usr/local/bin/goss --gossfile=/vagrant/regression-tests/goss-checks/goss.yaml validate $REPORT_FORMAT


ORANGE='\033[0;33m'
NO_COLOR='\033[0m'
echo -e "${ORANGE}Please note: You have to do manual checks for Exercise B.3, section \"If You Decide to Use CRL\""
echo -e "and everything after this. These checks are not yet implemented here for automated testing!${NO_COLOR}"
