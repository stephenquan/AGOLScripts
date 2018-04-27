#!/bin/bash -xe

[ "$PORTAL" == "" ] && PORTAL=https://www.arcgis.com

showSyntax() {
  cat <<EOF
addItem -h | --help
	     --title         title
	     --tags          tags
	     --type          type
	     --typeKeywords  typeKeywords
	     --description   description
        -u | --username      username
        -t | --token         token
EOF
}

i=0
ARGV=("$@")
while (( i < ${#ARGV[@]} )); do
  case "${ARGV[$i]}" in
  -h | --help    ) showSyntax ; exit 0 ;;
       --title   ) TITLE="${ARGV[$((++i))]}" ;;
       --tags    ) TAGS="${ARGV[$((++i))]}" ;;
       --type    ) TYPE="${ARGV[$((++i))]}" ;;
       --typeKeywords) TYPEKEYWORDS="${ARGV[$((++i))]}" ;;
       --description ) DESCRIPTION="${ARGV[$((++i))]}" ;;
  -u | --username) USERNAME="${ARGV[$((++i))]}" ;;
  -t | --token   ) TOKEN="${ARGV[$((++i))]}" ;;
  esac

  ((++i))
done

[ "$USERNAME" == "" ] && echo "Missing -u username" && showSyntax && exit 1
[ "$TITLE" == "" ] && echo "Missing --title title" && showSyntax && exit 1
[ "$TYPE" == "" ] && echo "Missing --type type" && showSyntax && exit 1
[ "$TYPEKEYWORDS" == "" ] && echo "Missing --typeKeywords typeKeywords" && showSyntax && exit 1
[ "$TOKEN" == "" ] && [ -f /tmp/generateToken.json ] && TOKEN=$(grep \"token\" /tmp/generateToken.json | sed -e s/.*\"token\":\\s*\"\\\(.*\\\)\".*/\\1/)

URL=$PORTAL/sharing/rest/content/users/$USERNAME/addItem

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
[ "$TYPEKEYWORDS"  != "" ] && ARGS+=(--data-urlencode "typeKeywords=$TYPEKEYWORDS")
[ "$DESCRIPTION"  != "" ] && ARGS+=(--data-urlencode "typeKeywords=$DESCRIPTION")

curl "${ARGS[@]}" | tee /tmp/addItem.json | tee /tmp/item.json

