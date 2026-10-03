#!/usr/bin/env bash
set -Eeu

readonly MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly REGEX="image_name\": \"(.*)\""
readonly JSON=`cat ${MY_DIR}/docker/image_name.json`
[[ ${JSON} =~ ${REGEX} ]]
readonly IMAGE_NAME="${BASH_REMATCH[1]}"

# Written down here so the gate fails when the floating base image moves to a
# different GnuCOBOL. Reading it from the image instead would compare the image
# against itself and pass whatever the move brought in.
readonly EXPECTED=3.2

# Asks the installed compiler through the name a kata calls. Matching on the
# leading major.minor lets a patch release through and stops only a minor or
# major move.
readonly ACTUAL=$(docker run --rm ${IMAGE_NAME} sh -c 'cobc --version')

if echo "${ACTUAL}" | grep -q "(GnuCOBOL) ${EXPECTED}"; then
  echo "VERSION CONFIRMED as ${EXPECTED}"
else
  echo "VERSION EXPECTED: ${EXPECTED}"
  echo "VERSION   ACTUAL: ${ACTUAL}"
  exit 42
fi
