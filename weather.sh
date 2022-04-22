#!/bin/bash

weather() {
    if [ -z $1 ]; then
        curl -s 'https://wttr.in/?format=3'
    else
        curl -s "https://wttr.in/$1?format=3"
    fi
}

weather $1
