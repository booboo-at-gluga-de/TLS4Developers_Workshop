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
echo -e "${ORANGE}Please note: Some tests are not yet automated and need to be done manually:"
echo -e " * Testing the Java Exercises${NO_COLOR}"
echo -e "      - A2:"
echo -e "            mvn -f /vagrant/exercises/A2/java_sample/pom.xml spring-boot:run"
echo -e "            curl http://localhost:12080"
echo -e "      - A4:"
echo -e "            mvn -f /vagrant/exercises/A4/java_sample/pom.xml spring-boot:run"
echo -e "            curl http://localhost:14080"
echo -e "${ORANGE} * Exercises after A.5 (if there are some)"
echo -e " * Exercises after B.5 (if there are some)"
echo -e "${NO_COLOR}"
