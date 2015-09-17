#!/bin/bash

function get_path()
{
    echo "${1}" | awk -F'd="' '{print $2}' | awk -F\" '{print $1}'
}

function get_svg_from_code()
{
    echo "${MAP_STR}" | grep "\"${1}\"" | awk -F\" '{print $4}'
}

function write_path_to_json()
{
    item="${1}"
    divider="${2}"
    code=$(echo "${item}" | awk -F\" '{print $2}')
    if [ ! "${code}" ]; then
        return
    fi
    svg_name="${SVG_DIR}/$(echo "${item}" | awk -F\" '{print $4}').svg"
    #
    CONTENT=$(cat "${svg_name}" | sed "s/\n//g" )
    CONTENT=$(get_path "${CONTENT}")
    #
    echo "\"${code}\":\"${CONTENT}\"${divider}" >> "${DEST}"
}

all_to_json()
{ 
    #begin
    printf "{" > "${DEST}"
    # begin
    echo "${MAP_STR}" | sed '$d' | while read item
    do
        write_path_to_json "${item}" ","
    done
    # the last
    item=$(echo "${MAP_STR}" | awk 'END{print}')
    write_path_to_json "${item}"
    #end
    printf "}" >> "${DEST}"
}


# function svg_in_paths()
# {
#     item="${1}"
#     divider="${2}"
#     code=$(echo "${item}" | awk -F\" '{print $2}')
#     if [ ! "${code}" ]; then
#         return
#     fi
#     svg_name="$(echo "${item}" | awk -F\" '{print $4}')"
#     # remove svg element
#     CONTENT=$(cat "${SVG_DIR}/${svg_name}.svg" | sed "s/<\/svg>//g" | sed 's/<svg xmlns="http\:\/\/www.w3.org\/2000\/svg">//g' )
#     # 
#     CONTENT=$(echo "${CONTENT}" | sed "s/<path/<path id=\"${svg_name}\"/g")
#     #
#     echo "${CONTENT}" >> "${DEST}"
# }
# all_to_svg()
# {
#     #begin
#     printf '<svg xmlns="http://www.w3.org/2000/svg">' > "${DEST}"
#     # begin
#     echo "${MAP_STR}" | sed '$d' | while read item
#     do
#         svg_in_paths "${item}" ","
#     done
#     # the last
#     item=$(echo "${MAP_STR}" | awk 'END{print}')
#     svg_in_paths "${item}"
#     #end
#     printf '</svg>' >> "${DEST}"
# }

# from_allsvg_to_single()
# {
#     DEST_DIR="svgs"
#     if [ ! -d "${DEST_DIR}" ]; then
#         mkdir "${DEST_DIR}"
#     fi
#     #
#     HEADER="$(echo "${MAP_STR}" | grep '<svg')"
#     #
#     MAP_STR="$(echo "${MAP_STR}" | grep "<path")"

#     echo "${MAP_STR}" | while read item
#     do
#         unicode=$(echo "${item}" | awk -F\" '{print $2}' | awk -F_ '{print $1}' )
#         echo "unicode = ${unicode}"
#         dest_file_path="${DEST_DIR}/${unicode}.svg"
#         if [ -f "${dest_file_path}" ]; then
#             echo
#         fi
#         SVG_CONTENT=$(echo "${HEADER}${item}</svg>" )
#         echo "${SVG_CONTENT}"  > "${dest_file_path}"
#     done
# }

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

#
# all_to_svg
# from_allsvg_to_single
all_to_json


