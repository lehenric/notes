#!/usr/bin/env bash
# vi:syntax=sh

# script to help taking notes with {n,}vim

NOTES_DIRECTORY="${HOME}/notes/school"
# css file used for html generation
export CSS_FILE=$(readlink -f "$0"/pandoc.css)

init() {
  mkdir -p "$NOTES_DIRECTORY"
}

usage() {
  cat 1>&2 << "EOF"
Usage: notes [ OPTIONS ] COURSE [ NAME ]
OPTIONS:
  -h,--help  prints this help
  -i,--init  initializes notes directory from config
  -l,--list COURSE   list course notes
  -d,--dir prints  directory of NOTES and exits
EOF
}

# takes COURSE and NAME as parameters
list() {
    COURSE="$1"
    [[ "$COURSE" == "--" ]] && COURSE=""
    lsd -la "$NOTES_DIRECTORY/${COURSE}"
}

# takes COURSE and NAME as parameters
main(){
    COURSE="$1"
    NAME="$2"
    mkdir -p "$NOTES_DIRECTORY/${COURSE}"
    (
        cd "$NOTES_DIRECTORY/${COURSE}" 
        nvim "${NAME%.md}.md"
    )
}

# optional 1 parameter - course
generate() {
    COURSE="$1"
    [[ "$COURSE" == "--" ]] && COURSE=""
    mkdir -p $NOTES_DIRECTORY/html
    (
        cd "$NOTES_DIRECTORY/$COURSE"
        find . -type f -name "*md" -exec sh -euc 'mkdir -p $2/$(dirname $1); pandoc --css $3 -o $2/${1%md}.html $1' sh {} $NOTES_DIRECTORY/html $CSS_FILE \;
    )
}

if [[ $# -le 0 ]]; then usage && exit 0; fi
options=$(getopt -l "gen-docs,help,init,list:,verbose,dir" -o "gdvhil:" -- "$@")


# set --:
# If no arguments follow this option, then the positional parameters are unset. Otherwise, the positional parameters 
# are set to the arguments, even if some of them begin with a ‘-’.
set -euo pipefail
eval set -- "$options"

while true
do
  case $1 in
    -v|--verbose)
      export verbose=1
      set -xv  # Set xtrace and verbose mode.
      ;;
    -d|--dir)
       echo "$NOTES_DIRECTORY"
       exit 0
       ;;
    -h|--help)
       usage
       exit 0
       ;;
    -l|--list)
      list "$2"
      exit 0
      ;;
    -i|--init)
      init
      exit 0
      ;;
    -g|--gen-docs)
      generate $2
      exit 0
      ;;
    --)
      shift
      export course=$1
      export name=$2
      main $1 $2
      break;;
  esac
  shift
done
