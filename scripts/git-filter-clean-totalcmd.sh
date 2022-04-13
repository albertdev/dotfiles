#!/bin/sh
# Reset particular ini values to a fixed state.
# Hard-coded gawk path is to make sure no that Windows version of gawk gets used - it turns the \n into another pair of \r\n
/bin/gawk -F= -v OFS='=' -v ORS='\r\n' -- '$1=="firstmnu"{$2="2211"}$1=="QuickSearchAutoFilter"{$2="0"}$1=="LastSearchOptions"{$2="96"}{print}'
