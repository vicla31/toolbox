#!/usr/bin/env bash
# List all files in a directory

function usage() {
    printf "\e[1;34musage:\e[0m\e[1m %s options <directory> [<keyword>]\e[0m

    Programm list existing filenames in the <directory>.
    If <keyword> is provided, programm only list filenames containing <keyword>

    \e[1;34mOPTIONS:\e[0m
      -h --help           Print this help and exit.
      -p --pretty         Pretty format (with directory names)
      -r -R --recursive   List filename in also in sub-directory
" "$PROGNAME"
}

function listfilesdir() {
  local dir="$1"
  local keyword="$2"

  if [[ $PRETTY -eq 1 ]]; then
    printf "*** Files in folder : \e[34m%s\e[0m\n" "$dir"
  fi
  local file
  for file in "$dir"/*; do
    local filename=${file##*/}
    if [[ -f $file ]] && [[ ! -L $file ]] && [[ $filename == *"$keyword"* ]]; then
      echo "$filename"
      ((COUNTER++))
    elif [[ $RECURSIVE -eq 1 ]] && [[ -d $file ]]; then
      listfilesdir "$file" "$keyword"
    fi
  done
}

# Function to genere global var depending of ARG
function commandargs() {
  # Gobal VAR
  PRETTY=0
  RECURSIVE=0
  KEYWORD=""
  DIRTOSCAN=""

  local args=()
  local arg
  # replace long options & let the positional arguments as before
  for arg; do
      case "$arg" in
          --help)           args+=( -h ) ;;
          --pretty)         args+=( -p ) ;;
          --recursive)      args+=( -r ) ;;
          *)                args+=( "$arg" ) ;;
      esac
  done

  set -- "${args[@]}"   # Replace arguments line with the edited one
  OPTIND=1              # Reset in case getopts has been used previously in the shell.
  while getopts "hpRr" OPTION; do
    case "$OPTION" in
      h) usage ; exit 0 ;;
      p) PRETTY=1 ;;
      r | R) RECURSIVE=1 ;;
      *) ;;
    esac
  done

  shift "$((OPTIND-1))"
  [ "${1:-}" = "--" ] && shift
  DIRTOSCAN="$1"
  KEYWORD="$2"
}

function main() {
  commandargs "${ARGS[@]}"

  if [ ! -d "$DIRTOSCAN" ]; then
    echo "ERROR : not a directory"
    usage
    exit 1
  fi

  listfilesdir "$DIRTOSCAN" "$KEYWORD"

  if [[ $PRETTY -eq 1 ]]; then
    printf "\e[1;34m%s\e[0m corresponding files in folder %s\n" $COUNTER "$DIRTOSCAN"
  fi
}

# Static global VAR
readonly PROGNAME=$(basename "$0")
readonly PROGDIR=$(readlink -m "$(dirname "$0")")
readonly ARGS=("$@")

main