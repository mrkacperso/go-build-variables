#!/usr/bin/env bash

function print_usage {
  printf "Usage: build.sh -v [-e] SRC_FILE\n"
  printf "\t-v\tProvide binary version, example: -v 0.0.1\n"
  printf "\t-e\tProvide target environment, any value different than \"release\" will result in production build, example: -v release\n"
  printf "\t-o\tOutput binary filename\n"
  printf "\t-h\tPrint help and exit\n"
  exit 1
}

# Iterate trough short arguments list and process arguments
while getopts "v:e:o:h" o; do
    case "${o}" in
        v)
            VERSION=${OPTARG}
            ;;
        e)
            ENV=${OPTARG}
            ;;
        o)
            OUTPUT_FILE=${OPTARG}
            ;;
        h)
            print_usage
            ;;
        *)
            printf "Error: Option undefined\n\n"
            print_usage
            ;;
    esac
done

# Discard processed arguments from arguments list ("OPTIND-1" is index of first unprocessed argument - source filename in this case)
shift $((OPTIND-1))

SRC_FILE="${BASH_ARGV[0]}"

# Version number and source filename is required
if [[ -z $VERSION ]]
then
  print_usage
fi

if [[ -z $SRC_FILE ]]
then
  print_usage
fi

# If output filename is not set, we will mimic how go by default handles this situation - source main filename without .ext
if [[ -z $OUTPUT_FILE ]]
then
    OUTPUT_FILE="${SRC_FILE%.*}"
fi

# Any value other than "development" will produce production build.
# This is to prevent building and accidental release of development builds which can be unsafe or unstable.
# Here we are appending \"rc-\" to version number and setting output filename to , but it can be for example
# setting another variable to indicate development build or building with different flags.
if [[ "$ENV" == "release" ]]
then
    OUTPUT_FILE="$OUTPUT_FILE-stable"
else
    VERSION="rc-$VERSION"
    OUTPUT_FILE="$OUTPUT_FILE-development"
fi


# Enable strict checking for variables initialization and exit codes.
set -euo pipefail

# Format \"%h\" for git log prints only short commit hashes in reverse chronological order,
# -n 1 returns first row - last commit
BUILD_HASH=$(git log --pretty=format:"%h" -n 1|head -1)

echo "Building: $SRC_FILE version: $VERSION from commit: $BUILD_HASH to file: $OUTPUT_FILE"
go build -ldflags "-X main.version=$VERSION -X main.build=$BUILD_HASH" -o "$OUTPUT_FILE" "$SRC_FILE"


