#!/bin/bash

#shopt -s extglob

file_path="/home/ewan/becode/Bash_Scripting_Introduction/Ewan_Gilchrist/Are_You_My_Friend"

if [ ! -f ~/.local/bin/bert ]; then
    case :$PATH: in
    *:$HOME/.local/bin:*)
        echo "You can put me in your path to make it easier to ask me things.."
        sleep 0.5
        echo -n "if you run:\nln -s $PWD/bert.sh ~/.local/bin/bert\n you will be able to ask me questions from anywhere! (on your computer)"
        echo -e "If you want to get rid of me after doing this.. :(\nthen you can run:  unlink (which bert) "
        ;;
    *)
        echo "$HOME/.local/bin not in $PATH, maybe add it to you path or put me somewhere else.." >&2
        ;;
    esac
fi

calculator() {
    source $file_path/calculate.sh
}

timeDate() {
    source $file_path/time.sh
}

jokes() {
    source $file_path/jokes.sh
}

weather() {
    source $file_path/weather.sh
}

introPostSpeak() {
    if [ "$speak" == "yes" ]; then
        echo "Now\n"
        espeak-ng "Now"
        sleep 1
        espeak-ng "Shall I you tell what I can do? Type help if you want me to. Or if you already know go ahead and type it now..."
        echo -e "Shall I you tell what I can do?\nType help if you want me to\nor if you already know go ahead and type it now..."
    else
        echo -e "Now"
        sleep 1
        echo -e "Shall I you tell what I can do?\nType help if you want me to\nor if you already know go ahead and type it now..."
    fi
}

intro() {
    if [ -z $1 ]; then
        echo "Hello, my name is Bert."
        echo "...."
        sleep 1
        echo "I am a bot 🤖"
        sleep 1
        echo "You can ask me lots of things."
        sleep 1
        echo "But first, I can speak to you if you want..."
        sleep 0.5
        echo "Will you let me speak?"
        read speak
        cheakForEspeak
        echo "ok.."
        sleep 0.2
        introPostSpeak
        read -a choice
        function=${choice[0]}
        argument1=${choice[1]}
        argument2=${choice[2]}
        argument3=${choice[3]}
    else
        if [ "$1" == "speak" ]; then
            speak="yes"
            function=$2
            argument1=$3
            argument2=$4
            argument3=$5
        else
            function=$1
            argument1=$2
            argument2=$3
            argument3=$4
        fi
    fi
}

cheakForEspeak() {
    if [ "$speak" == "yes" ] && ! command -v espeak-ng &>/dev/null; then
        echo -e "You need to install espeak if you want me to speak..\n have a read here: https://https://github.com/espeak-ng/espeak-ng"
        exit 1
    fi
}

main() {
    #Interactive Mode
    intro $1 $2 $3 $4 $5
    #echo from main $function $arguments
    if [ -z $function ]; then
        echo "Don't be shy! Ask away."
    else
        case $function in
        weather | Weather)
            echo $argument1
            if [ -z $argument1 ]; then
                case $speak in
                yes)
                    espeak-ng "Here is the Weather where you are"
                    echo $(weather) | sed "s/+//" | espeak-ng
                    ;;
                *)
                    weather
                    ;;
                esac
            else
                echo -e "Here is the Weather in $argument1"
                if [ "$speak" == "yes" ]; then
                    espeak-ng "Here is the Weather in $argument1"
                    weather $argument1
                    echo $(weather $argument1) | sed "s/+//" | espeak-ng
                else
                    weather $argument1
                fi
            fi
            ;;
        Joke | joke)
            if [ "$speak" == "yes" ]; then
                echo "Harvesting a fresh joke from the web....."
                espeak-ng "Harvesting a fresh joke from the web....."
                echo -e "\n"
                returnedJoke=$(jokes)
                echo $returnedJoke
                echo $returnedJoke | sed "s/+//" | espeak-ng
            else
                echo "Harvesting a fresh joke from the web....."
                echo -e "\n"
                jokes
            fi
            ;;
        time | Time)
            if [ "$speak" == "yes" ]; then
                timeDate
                echo $(timeDate) | sed "s/+//" | espeak-ng
            else
                timeDate
            fi
            ;;
        calculate | Calculate)
            #echo "case worked"
            if [ -z $argument2 ]; then
                #echo "failed if"
                response="You have to give two numbers and an operator, like 2 + 3"
                case $speak in
                yes)
                    echo $response
                    echo $response | espeak-ng
                    ;;
                *)
                    echo $response
                    ;;
                esac
            else
                calculation=$(calculator $argument1 $argument2 $argument3)
                #echo "else worked"
                case $speak in
                yes)
                    echo "$argument1 $argument2 $argument3 is $calculation"
                    echo "$argument1 $argument2 $argument3 is $calculation" | espeak
                    ;;
                *)
                    echo "$argument1 $argument2 $argument3 is $calculation"
                    ;;
                esac
            fi
            ;;
        *)
            echo "dunno sorry"
            ;;
        esac
    fi
}

main $1 $2 $3 $4 $5
