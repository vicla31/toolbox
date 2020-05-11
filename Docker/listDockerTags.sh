#!/usr/bin/env bash
	

function usage(){
	printf "listDockerTags usage :
	\tlistDockerTags.sh -h
	\tlistDockerTags.sh [-t tag] repository
	\t-t --tag       : print only tags contening this value
	\t-h --help      : print this help.\n"
}

function listTag(){
i=0

while [ $? == 0 ]
do 
   ((i++))
   curl https://registry.hub.docker.com/v2/repositories/library/$1/tags/?page=$i 2>/dev/null|jq '."results"[]["name"]'
done
}


# Help is displayed if no arg are passed
if [ $# -eq 0 ]
then
	usage
fi


# Reading options
TEMP=$(getopt -o h::t: --long help::tag: -- "$@")
if [ $? -ne 0 ]
then
    exit 1
fi

eval set -- "$TEMP"

while true; do
	case "$1" in
		-h|--help)
		  usage;
			exit 0;;
		-t|--tag)
		  tags=$2;
		  echo "Tag $tags";
		  shift 2 ;;
		*) break;
	esac
done

repo=$2;

if [[ -z ${repo} ]]; then
	echo "Repository is required"
	usage
	exit 1
elif [ -z $tags ]
then
	listTag $repo
else
	listTag $repo | grep $tags
fi


exit 0
