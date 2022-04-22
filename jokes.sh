#!/bin/bash

randomNumber=$((1 + $RANDOM % 6000))

getJoke() {
    curl -s https://raw.githubusercontent.com/taivop/joke-dataset/master/wocka.json | jq ".[$randomNumber].body"
}

formatOutput() {
    echo -e $(getJoke) | sed 's/\\/ /g'
}

formatOutput
