#!/bin/bash
# make -C apiary publish

mc.uploader -c devDoc -t $SLASH_DEVELOPER_SPACE_KEY -s $SLASH_DEVELOPERS_SPACE -p docs/index.md
