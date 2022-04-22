#!/bin/bash

dateTime() {
    echo -e "Today is $(date +%B) $(date +%d | sed s/0//) and it is a $(date +%A)\nThe current time is: $(date +%T)"
}

dateTime
