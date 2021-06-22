#!/bin/sh
source ${BASH_SOURCE%/*}/env.sh

terminal-notifier -title '👨 Vaccin COVID' -message "Starting bot for $RAMQ / $PHONE"
osascript -e "tell application \"Messages\" to send \"\" to buddy \"$ALERT_BY_PHONE\""

SESSION_TIMEOUT=$(expr $SESSION_RENEWAL '*' 60)

IFS='#'
read -r -a PERIODS <<< "$PERIODS_DEF"


while true; do sleep 10;

if [ -z ${JOB_ID+x} ]; then
  json=$(curl 'https://api3.clicsante.ca/v3/appointments/jobs' \
    -X 'POST' \
    -H 'authority: api3.clicsante.ca' \
    -H 'pragma: no-cache' \
    -H 'cache-control: no-cache' \
    -H 'product: clicsante' \
    -H 'authorization: Basic cHVibGljQHRyaW1vei5jb206MTIzNDU2Nzgh' \
    -H 'content-type: application/json;charset=UTF-8' \
    -H 'accept: application/json, text/plain, */*' \
    -H 'x-trimoz-role: public' \
    -H 'origin: https://portal3.clicsante.ca' \
    -H 'referer: https://portal3.clicsante.ca/' \
    --data-raw "{\"nam\":\"$RAMQ\",\"phone\":\"$PHONE\"}" \
    --compressed \
    --silent)
  JOB_ID=$(echo "$json" | jq -r '.job')
  echo ""
  echo "JOB_ID $JOB_ID"
  MFA_CODE=$(IMAP_USER=$IMAP_USER IMAP_PASSWORD=$IMAP_PASSWORD IMAP_HOST=$IMAP_HOST IMAP_PORT=$IMAP_PORT EMAIL_SUBJECT=$EMAIL_SUBJECT node mfa.js | xargs)
  echo "MFA_CODE $MFA_CODE"
  session_started=$(date +%s)
  session_end=$(expr $session_started '+' $SESSION_TIMEOUT)

  json=$(curl "https://api3.clicsante.ca/v3/appointments/jobs/${JOB_ID}/code" \
    -X 'POST' \
    -H 'authority: api3.clicsante.ca' \
    -H 'pragma: no-cache' \
    -H 'cache-control: no-cache, no-store, must-revalidate' \
    -H 'product: clicsante' \
    -H 'authorization: Basic cHVibGljQHRyaW1vei5jb206MTIzNDU2Nzgh' \
    -H 'accept: application/json, text/plain, */*' \
    -H 'x-trimoz-role: public' \
    -H 'origin: https://clients3.clicsante.ca' \
    -H 'referer: https://clients3.clicsante.ca/' \
    --data-raw "{\"code\":\"${MFA_CODE}\"}" \
    --compressed \
    --silent)

  JOB_TOKEN=$(echo "$json" | jq -r '.token')
  echo "JOB_TOKEN $JOB_TOKEN"

fi

for PERIOD in "${PERIODS[@]}"
do
  current_time=$(date +%s)
  if [ $current_time -gt $session_end ]; then
    echo ""
    echo "Renew session"
    unset JOB_ID
    continue
  fi

  IFS='|'
  read -r -a DATES <<< "$PERIOD"
  START_DATE="${DATES[@]:0:1}"
  END_DATE="${DATES[@]:1:1}"
  printf "."

  json=$(curl "https://api3.clicsante.ca/v3/establishments/60089/schedules/public?dateStart=${START_DATE}&dateStop=${END_DATE}&service=${SERVICE_ID}&timezone=America/Toronto&places=${PLACE_ID}&filter1=undefined&filter2=undefined&filter3=undefined" \
    -H 'authority: api3.clicsante.ca' \
    -H 'pragma: no-cache' \
    -H 'cache-control: no-cache, no-store, must-revalidate' \
    -H 'product: clicsante' \
    -H 'authorization: Basic cHVibGljQHRyaW1vei5jb206MTIzNDU2Nzgh' \
    -H 'accept: application/json, text/plain, */*' \
    -H 'x-trimoz-role: public' \
    -H "x-trimoz-appointment-update-job-id: $JOB_ID" \
    -H "x-trimoz-appointment-update-job-token: $JOB_TOKEN" \
    -H 'origin: https://clients3.clicsante.ca' \
    -H 'referer: https://clients3.clicsante.ca/' \
    --compressed \
    --silent)

  status=$(echo "$json" | jq -r '.status')
  if [ $status = 404 ]; then
    echo ""
    echo "Session expired"
    unset JOB_ID
    continue
  fi
  availabilities=$(echo "$json" | jq -r '.availabilities')

  if [ "$availabilities" != "[]" ]; then
    echo ""
    terminal-notifier -title '👨 Vaccin COVID' -message 'Rendez-vous COVID disponible!' -open "https://clients3.clicsante.ca/60089/take-appt/?jobId=$JOB_ID&jobToken=$JOB_TOKEN" -sound default
    osascript -e "tell application \"Messages\" to send \"Rendez-vous COVID disponible!\n${availabilities//\"} https://clients3.clicsante.ca/60089/take-appt/?jobId=$JOB_ID&jobToken=$JOB_TOKEN\" to buddy \"$ALERT_BY_PHONE\""
    echo "Availabilities: $availabilities"
    echo "https://clients3.clicsante.ca/60089/take-appt/?jobId=$JOB_ID&jobToken=$JOB_TOKEN"
    sleep 120
  fi

  printf ":"
done

done;
