#!/bin/dash
# Taken from https://unix.stackexchange.com/a/80153/70874
tr ':' '\n' <<< "$PATH"
