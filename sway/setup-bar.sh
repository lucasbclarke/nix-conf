#!/usr/bin/env bash

if [[ $(pgrep 'quickshell') ]]; then
    echo running
else
    exec qs
fi

