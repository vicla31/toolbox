#!/usr/bin/env bash
	

function usage(){
	printf "Utilisation du script :\n"
	printf "\tlistDockerTags.sh -h\n"
	printf "\tlistDockerTags.sh [-t tag] repository\n"
	printf "\t-t --tag       : affiche seulement les tags contenant cette valeur\n"
	printf "\t-h --help      : affiche ce message.\n"
}

function listeTag(){
i=0

while [ $? == 0 ]
do 
   i=$((i+1))
   curl https://registry.hub.docker.com/v2/repositories/library/$1/tags/?page=$i 2>/dev/null|jq '."results"[]["name"]'
done
}


#si pas d'arguments: on affiche l'aide
if [ $# -eq 0 ]
then
	usage
fi


# lecture des options
TEMP=`getopt -o h::t: --long help::tag: -- "$@"`
if [ $? != 0 ]
then
    exit 1
fi

eval set -- "$TEMP"

while true; do
	case "$1" in
		-h|--help) usage;
			exit 0;;
		-t|--tag) tags=$2; echo "Tag $tags"; shift 2 ;;
		*) break;
	esac
done

repo=$2;

if [ -z $repo ]
then
	echo "Il faut fournir le repository"
	usage; exit 1
elif [ -z $tags ]
then
	listeTag $repo
else
	listeTag $repo | grep $tags
fi


exit 0
