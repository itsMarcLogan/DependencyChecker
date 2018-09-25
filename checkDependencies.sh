#!/bin/bash

#========================***===========================#
#	       [ MARC LOGAN - DependenciesChecker! ]         #
#                                                      #
# * add this file to your project.                     #
# * edit the "required"-array below.                   #
# * add "dependencies;" in your script to invoke this. #
#                                                      #
# * Github: https://github.com/itsMarcLogan            #
#========================***===========================#

#List dependencies in array.
required=(ruby curl perl gcc nodejs python2 python3 lighttpd curl);

#Beauty is on the outside.
aGood="[\033[32m+\033[37m]\t";
aBad="[\033[31m!\033[37m]\t";
aNeut="[\033[93m?\033[0m]\t";

function keepUpdated(){
currentTime=$(date +%s);
	if [[ -e .updated.txt ]]; then
		updated=$(head -n 1 .updated.txt);
	else
		updated=$(date +%s);
		echo $(date +%s) > .updated.txt
		apt update;
	fi;
	#automatically update after 3 hours (3600*3=10800)
	if [[ `expr ${currentTime} - ${updated}` > 10800 ]]; then
		echo ${currentTime} > .updated.txt
		apt update && apt upgrade;
	fi;
}

function promptInstall(){
	i=0;
	while [[ $i < ${#notInstalled[@]} ]]; do
		echo -ne "${aNeut}This is needed. Install \033[32m${notInstalled[$i]}\033[37m?";
		read -p "[y/n] " answer;
		answer=${answer,,}
		if [[ ${answer:0:1} == 'y' ]]; then
			keepUpdated;
			apt install ${notInstalled[$i]};
		fi;
		let "i++";
	done;
}

function dependencies(){
	declare -a notInstalled;
	while [[ $i < ${#required[@]} ]]; do
		check=$(command -v ${required[$i]});
		if [[ $check ]]; then
			echo -e "${aGood}${required[$i]} installed.";
		else
			echo -e "${aBad}\033[31m${required[$i]}\033[37m not installed.";
			notInstalled+=(${required[$i]});
		fi;
		let "i++";
		sleep 0.1s;
	done;
	echo -e "\n";
	if [[ ${#notInstalled[@]} > 0 ]]; then
		promptInstall;
	else
		sleep 0.5s;
		echo -e "${aGood}Dependencies installed!";
		sleep 0.2s;
	fi;
}
