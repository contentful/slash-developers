#!/bin/bash

mc.uploader -t $(SLASH_DEVELOPERS_API_KEY) -s $(SLASH_DEVELOPERS_SPACE) -c devDoc -p docs/index.md
