#!/bin/bash
source checkDependencies.sh

echo -e "${aGood}Welcome to my script!";
echo -e "${aNeut}Checking for dependencies..";
sleep 2s;

echo -e "\n\n";
dependencies;
tput cup $(tput lines)
