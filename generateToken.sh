#!/bin/bash -e

[ "$PORTAL" == "" ] && PORTAL=https://www.arcgis.com

showSyntax() {
  cat <<EOF
generateToken.sh -u username -p password
EOF
}

while getopts "hu:p:" opt; do
  case ${opt} in
  u) USERNAME=$OPTARG ;;
  p) PASSWORD=$OPTARG ;;
  h) showSyntax ; exit 0
  esac
done

[ "$USERNAME" == "" ] && echo "Missing -u username" && showSyntax && exit 1
[ "$PASSWORD" == "" ] && echo "Missing -p password" && showSyntax && exit 1

URL=$PORTAL/sharing/rest/generateToken

ARGS=()
ARGS+=(--silent)
ARGS+=(--show-error)
ARGS+=(--insecure)
ARGS+=(-X POST)
ARGS+=("$URL")
ARGS+=(--data-urlencode "username=$USERNAME")
ARGS+=(--data-urlencode "password=$PASSWORD")
ARGS+=(--data-urlencode "referer=$PORTAL")
ARGS+=(--data-urlencode "f=pjson")

curl "${ARGS[@]}" | tee /tmp/generateToken.json

