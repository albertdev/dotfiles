#!/bin/sh
# Blank out the recent files entries, lock a bunch of UI flags to preferred values
/bin/gawk -F= -v OFS='=' -- \
    '$1~/^Recent/{$2=""}$1=="Geometry"{$2="600,400"}$1=="Position"{$2="0,22"}($1=="ShowIdenticalFiles"||$1=="ShowLineNumbers"||$1~/^ShowWhiteSpace/||$1=="WordWrap"){$2=1}{print}'
