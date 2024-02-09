#!/bin/bash
set -e

DMRID_FILE=/usr/local/etc/DMRIds.dat
LOCAL_DMRID_FILE=/root/DMRIds.dat

CHECK_MODE=yes
TXT_ACTION="would add"
case "$1" in
  -f | --force ) 
    CHECK_MODE=no
    TXT_ACTION="added"
    ;;
esac

if [ ! -f "$DMRID_FILE" ]; then
  echo "E: DMR Id file $DMRID_FILE does not exist"
  exit 1
fi

if [ ! -f "$LOCAL_DMRID_FILE" ]; then
  echo "E: local DMR Id file $LOCAL_DMRID_FILE does not exist"
  exit 1
fi

rs=0
exec < "$LOCAL_DMRID_FILE"
while read id callsign talkeralias; do
  echo "checking $id $callsign $talkeralias"
  grep -E "^$id[[:space:]]+" "$DMRID_FILE" > /dev/null && \
    continue || :

  if [ "$CHECK_MODE" = no ]; then
    echo -e "$id\t$callsign\t$talkeralias" >> "$DMRID_FILE"
  else
    rs=$((rs+1))
  fi
  echo "$TXT_ACTION $id $callsign $talkeralias"
done
exit $rs
