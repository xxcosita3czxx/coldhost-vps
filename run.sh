#!/bin/sh
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

DIR=$PWD # get current dir
# if current dir is /root print ~
if [ "$PWD" = "/root"* ]; then
    DIR="~${PWD#/root}"
fi

printf "\033c"
printf "${GREEN}╭─────────────────────────────────────────────╮${NC}\n"
printf "${GREEN}│                                             │${NC}\n"
printf "${GREEN}│               Coldhost.eu VPS               │${NC}\n"
printf "${GREEN}│                                             │${NC}\n"
printf "${GREEN}╰─────────────────────────────────────────────╯${NC}\n"
printf "                                                                                               \n"
printf "root@coldhost:${DIR}#                                                                             \n"

run_cmd() {
    read -p "root@coldhost:$DIR# " CMD
    eval "$CMD"

    # Update DIR after executing command
    DIR=$PWD
    if [ "$PWD" = "/root"* ]; then
        DIR="~${PWD#/root}"
    fi
    
    printf "root@coldhost:$DIR# \n"
    run_user_cmd
}

run_user_cmd() {
    read -p "user@coldhost:$DIR# " CMD2
    eval "$CMD2"

    # Update DIR after executing command
    DIR=$PWD
    if [ "$PWD" = "/root"* ]; then
        DIR="~${PWD#/root}"
    fi
    
    printf "root@coldhost:$DIR# \n"
    run_cmd
}

run_cmd
