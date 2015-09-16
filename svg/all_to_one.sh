#!/bin/bash


function get_svg_from_code()
{
    echo "${MAP_STR}" | grep "\"${1}\"" | awk -F\" '{print $4}'
}

function write_to_dest()
{
    item="${1}"
    divider="${2}"
    code=$(echo "${item}" | awk -F\" '{print $2}')
    if [ ! "${code}" ]; then
        return
    fi
    svg_name="${SVG_DIR}/$(echo "${item}" | awk -F\" '{print $4}').svg"
    #
    CONTENT=$(cat "${svg_name}" | sed 's/"/\\"/g')
    #
    echo "\"${code}\":\"${CONTENT}\"${divider}" >> "${DEST}"
}

##
MAP="${1}"
DEST="${2}"
SVG_DIR="singles"
MAP_STR=$(cat "${MAP}")

if [ ! "${DEST}" ]; then
    DEST="dest.json"
fi

if [ -f "${DEST}" ]; then
    rm "${DEST}"
fi

#begin
printf "{" > "${DEST}"
# begin
echo "${MAP_STR}" | sed '$d' | while read item
do
    write_to_dest "${item}" ","
done
# the last
item=$(echo "${MAP_STR}" | awk 'END{print}')
write_to_dest "${item}"
#end
printf "}" >> "${DEST}"

# ls "${SVG_DIR}" | while read files
# do
#     CONTENT=$(cat "${SVG_DIR}/${files}" | sed 's/"/\\"/g')
#     NAME="${files%.*}"
#     echo "${NAME}   code=$(get_code "${NAME}")"
#     # echo "${CONTENT}"
# done