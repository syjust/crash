#!/bin/bash

# ------------------------------------------------------------------------------
# C O N S T A N T S 
# ------------------------------------------------------------------------------
ENV_SHELL_PATH="shell/core"
ENV_STANDALONE_JAR="$ENV_SHELL_PATH/target/crsh.shell.core-1.2.7-SNAPSHOT-standalone.jar"

# ------------------------------------------------------------------------------
# F U N C T I O N S 
# ------------------------------------------------------------------------------
function testEnv() {
	ret=0
	echo "testing environment variables"
	for e in ${!ENV_*} ; do
		eval "e_path=\$$e"
		if [ ! -e "$e_path" ] ; then	
			echo "$e : $e_path not found !"
			let ret++
		fi
	done
	return $ret
}

function printOptions() {
	echo -en "\t"
	if [ -z "$2" ] ; then
		printf "%s\n" "$1"
	else
		printf "%-3s : %s\n" "$1" "$2"
	fi
}
function usage() {
	echo
	if [ ! -z "$1" ] ; then
		echo -e "INFO : $1\n"
	fi
	echo "USAGE: $0 option"
  printOptions "options are"
	printOptions "-s" "launch the standalone version"
	printOptions "-t" "launch the maven test version"
	echo
}

# RUN FUNCTION
# ======================================
#
#	take -s or -t as ARG to launch in
#
# maven test version
# or standalone version
#
function run() {
	local ret=10
	if [ "x$1" == "x-t" ] ; then
		# maven test version
		cd $ENV_SHELL_PATH && mvn test -Pmain
		ret=$?
	elif [ "x$1" == "x-s" ] ; then
		# Standalone version
		java -jar $ENV_STANDALONE_JAR
		ret=$?
	else
		usage "no args found" $ret
	fi
	return $ret
}


# ------------------------------------------------------------------------------
# R U N   S C R I P T 
# ------------------------------------------------------------------------------

testEnv \
	&& run $@
