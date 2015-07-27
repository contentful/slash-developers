#!/bin/bash

# Usage: slackpost "<webhook_url>" "<channel>" "<message>"

webhook_url=$1
if [[ $webhook_url == "" ]]; then
  echo "No webhook_url specified"
  exit 1
fi

shift
channel=$1
if [[ $channel == "" ]]
then
  echo "No channel specified"
  exit 1
fi

shift

text=$*

if [[ $text == "" ]]
then
  echo "No text specified"
  exit 1
fi

escapedText=$(echo $text | sed 's/"/\"/g' | sed "s/'/\'/g" )
json="{\"channel\": \"$channel\", \"text\": \"$escapedText\", \"username\":\"deployer\"}"

curl -s -d "payload=$json" "$webhook_url"
