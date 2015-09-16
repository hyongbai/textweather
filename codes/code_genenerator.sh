#!/bin/bash

FILE="${1}"
DEST="${FILE%.*}.json"

printf "{" > ${DEST}

#get except the last line
cat  "${FILE}" | sed '$d' | awk -F: '{printf ("\"%s\" : \"%s\",", $1, $2)}' >> ${DEST}

# add the last line
S_3200=$(cat "${FILE}"  | awk 'END{print}'| awk -F:  '{print $2}')

printf "\"3200\" : \"${S_3200}\"" >> ${DEST}

printf "}" >> ${DEST}

