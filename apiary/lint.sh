#!/bin/bash

BLUEPRINT=$1

if [ -z "$BLUEPRINT" ]; then
	echo "Usage: $0 blueprint-file" >&2
	exit 1
fi

which jq >/dev/null 2>&1
if [ $? -ne 0 ]
then
	echo 'Please install `jq` to lint blueprints.' >&2
	exit 1
fi

echo "Linting $BLUEPRINT..."

# Sanity check for hercule errors, because that does not set its exit status correctly :/
grep -q '^:' "$BLUEPRINT"
if [ $? -eq 0 ]
then
	echo 'Blueprint contains unresolved partials, check hercule output for errors.' >&2
	exit 1
fi

TMPFILE2=`mktemp $TMPDIR/tmp.XXXXXX`

curl -s -X POST --data-binary @"$BLUEPRINT" 'https://api.apiblueprint.org/parser' \
	--header 'Content-Type: text/vnd.apiblueprint' \
	--header 'Accept: application/vnd.refract.parse-result+json' >"$TMPFILE2"

# We do not want to fail the build if the API is unreachable
if [ $? -ne 0 ]
then
	echo 'Failed to lint via API blueprint API, skip linting...' >&2
	exit 0
fi

ERROR="`cat "$TMPFILE2"|jq '.error.message'`"

if [ "$ERROR" == "null" ]; then

EXPRESSION='.content[] | select(.meta.classes[0] == "warning")'
WARNINGS=`cat "$TMPFILE2"|jq -e "$EXPRESSION | .content"`
echo "$WARNINGS"
[[ "$WARNINGS" == "" ]]
EXIT_CODE=$?

else

echo "$ERROR"
exit 1

fi

rm -f "$TMPFILE2"

exit $EXIT_CODE
