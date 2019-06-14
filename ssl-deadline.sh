#!/bin/bash
# The script counts days until SSL expiration date

function error_empty () {
  echo "ERROR: Host not specified
  Usage: $0 example.com"
}

function error_resolve () {
  echo "ERROR: Host $1 can not be resolved
  Usage: $0 example.com"
}

function pre_check () {
  if [ -z "$1" ]; then
    error_empty
    exit 1
  fi

  host "$1" &> /dev/null
  result=$?
  if [ "$result" -eq 1 ]; then
    error_resolve $1
    exit 1
  fi
}

function count_days () {
  i_hostname="$1"
  i_port=443

  i_deadline=$(date -d "$(echo | openssl s_client -connect $i_hostname:$i_port 2> /dev/null | openssl x509 -noout -enddate | cut -d = -f 2)" +"%s")
  i_today=$(LANG=en_us_88591; date +"%s")

  i_days=$(($(($i_deadline-$i_today))/86400))

  echo $i_days
}

################################################################################
# MAIN                                                                         #
################################################################################

pre_check "$1"
count_days "$1"
exit 0
