#!/bin/bash -xe

[ "$PORTAL" == "" ] && PORTAL=https://www.arcgis.com

showSyntax() {
  cat <<EOF
portalSelf -t token
EOF
}

while getopts "ht:" opt; do
  case ${opt} in
  t) TOKEN=$TOKEN ;;
  h) showSyntax ; exit 0
  esac
done

[ "$TOKEN" == "" ] && [ -f /tmp/generateToken.json ] && TOKEN=$(grep \"token\" /tmp/generateToken.json | sed -e s/.*\"token\":\\s*\"\\\(.*\\\)\".*/\\1/)

URL=$PORTAL/sharing/rest/portals/self

ARGS=()
ARGS+=(--silent)
ARGS+=(--show-error)
ARGS+=(--insecure)
ARGS+=(-X POST)
ARGS+=("$URL")
ARGS+=(--data-urlencode "f=pjson")
[ "$TOKEN" != "" ] && ARGS+=(--data-urlencode "token=$TOKEN")

curl "${ARGS[@]}" | tee /tmp/portalsSelf.json

