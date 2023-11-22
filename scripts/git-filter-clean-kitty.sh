#!/bin/sh
# Reset particular ini values to a fixed state.
# Hard-coded gawk path is to make sure no that Windows version of gawk gets used - it turns the \n into another pair of \r\n
/bin/gawk -F= -v OFS='=' -v ORS='\r\n' -- \
  '$1=="configdir"{$2="REPLACEME"}'
