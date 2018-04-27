#!/bin/bash -xe

[ "$PORTAL" == "" ] && PORTAL=https://www.arcgis.com

showSyntax() {
  cat <<EOF
deleteItem -h | --help
           -u | --username  username
           -i | --itemid    itemid
           -t | --token     token
EOF
}

i=0
ARGV=("$@")
while (( i < ${#ARGV[@]} )); do
  case "${ARGV[$i]}" in
  -h | --help    ) showSyntax ; exit 0 ;;
  -i | --itemid  ) ITEMID="${ARGV[$((++i))]}" ;;
  -u | --username) USERNAME="${ARGV[$((++i))]}" ;;
  -t | --token   ) TOKEN="${ARGV[$((++i))]}" ;;
  esac

  ((++i))
done

[ "$TOKEN" == "" ] && [ -f /tmp/generateToken.json ] && TOKEN=$(grep \"token\" /tmp/generateToken.json | sed -e s/.*\"token\":\\s*\"\\\(.*\\\)\".*/\\1/)
[ "$ITEMID" == "" ] && [ -f /tmp/item.json ] && ITEMID=$(grep \"id\" /tmp/item.json | sed -e s/.*\"id\":\\s*\"\\\(.*\\\)\".*/\\1/)

[ "$USERNAME" == "" ] && echo "Missing -u username" && showSyntax && exit 1
[ "$ITEMID" == "" ] && echo "Missing --itemid itemid" && showSyntax && exit 1
[ "$TOKEN" == "" ] && echo "Missing --token token" && showSyntax && exit 1

URL=$PORTAL/sharing/rest/content/users/$USERNAME/items/$ITEMID/delete

ARGS=()
ARGS+=(--silent)
ARGS+=(--show-error)
ARGS+=(--insecure)
ARGS+=(-X POST)
ARGS+=("$URL")
ARGS+=(--data-urlencode "f=pjson")
[ "$TOKEN" != "" ] && ARGS+=(--data-urlencode "token=$TOKEN")
[ "$TITLE" != "" ] && ARGS+=(--data-urlencode "title=$TITLE")
[ "$TAGS"  != "" ] && ARGS+=(--data-urlencode "tags=$TAGS")
[ "$TYPE"  != "" ] && ARGS+=(--data-urlencode "type=$TYPE")

curl "${ARGS[@]}" | tee /tmp/deleteItem.json

