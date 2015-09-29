#!/bin/bash
URLS=('git@gitcafe.com:hyongbai/textweather.git','git@github.com:hyongbai/textweather.git')
#sed -i '' 's/"official"/"'$CH'"/g'

COMMENT="${1}"

if [ ! "${COMMENT}" ]; then
    echo "NO COMMENT!!!"
    exit
fi

# commit modification
git add .
git commit -m "${COMMENT}"

#
for URL in "${URLS[@]}"
do
    echo "change remote url to ${URL}"
    git remote set-url origin "${URL}"
    git push
done

echo "DONE!!!"