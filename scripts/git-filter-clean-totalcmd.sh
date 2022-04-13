#!/bin/sh
# Reset particular ini values to a fixed state.
# Sadly GNU sed seems to turn the file into a line-feed delimited one rather than CRLF
#sed 's/^\(firstmnu\)=.*/\1=2211/;s/^\(QuickSearchAutoFilter\)=.*/\1=0/;s/^\(LastSearchOptions\)=.*/\1=96/'
#gawk -F= -- '$1=="firstmnu"{print $1"=2211";next}$1=="QuickSearchAutoFilter"{print $1"=0";next}$1=="LastSearchOptions"{print $1"=96";next}1{print}'
gawk -F= -v OFS='=' -- '$1=="firstmnu"{$2="2211"}$1=="QuickSearchAutoFilter"{$2="0"}$1=="LastSearchOptions"{$2="96"}{print}'
