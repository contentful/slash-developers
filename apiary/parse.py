#!/usr/bin/env python

#
# Script for parsing the existing developer docs HTML and extracting
# all curl commands.
#

from BeautifulSoup import BeautifulSoup as soup

for pre in soup(file('cma.html')).findAll('pre', {"class": "highlight shell"}):
    command = pre.text

    print command.replace('\&#x000A;', ' ').replace('\t', '')
