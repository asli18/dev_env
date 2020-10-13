#!/bin/bash

<<com
Add git commit id to the end of filename of bin file.

Andes IDE post-build script
1. Get the project name
2. Copy and rename the output bin file
   - result: [project name]_[git commit ID].bin
com

LRED='\e[91m'
YELLOW='\e[33m'
NC='\e[0m'

head_sha_id=$(git show --summary | head -1 | awk '{ print substr($2, 1, 8) }')

# Check if Project file exists
project_file_path="../.project"
if [ ! -f ${project_file_path} ]; then
    echo "Project file not exists, path: \"${project_file_path}\""
    exit 1
fi

# === Extract string of Project name ===
if [ $# -ge 1 ] && [ $1 == "1" ]; then
# Method 1
{
    # Print only first matching line
    project_name=$(awk '/<name>/{print $0; exit;}' ${project_file_path})
    #project_name=$(grep -m1 \<name\> ${project_file_path})
    #project_name=$(sed -n '/<name>/p ; /<\/name>/q' ${project_file_path})
    #echo "${project_name}"

    # Remove prefix(<name>) & suffix(</name>)
    project_name=$(sed -e 's/.*<name>*//' -e 's/<\/name>//' <<< $project_name)
    #echo "${project_name}"
}
else
# Method 2
{
    project_name=$(awk 'BEGIN{FS="<name>"; RS="</name>";}
                        { if (NR==1) {print $2; exit} }' \
                        ${project_file_path})
}
fi
# ===============================================

# === Fix DOS format issue ===
#sed $'s/\r$//'     # DOS to Unix
#sed $'s/$/\r/'     # Unix to dos

#project_name=$(sed $'s/\r$//' <<< ${project_name})
project_name=$(tr -d "\r"  <<< ${project_name})

# ===============================================

echo "Project Name: ${project_name}"

find_num=$(find ./output -type f -name "${project_name}\.bin" -printf '.' | wc -c)

if [ ${find_num} -eq 1 ]; then
    find ./output -type f -name "${project_name}\.bin" \
         -exec bash -c \
         'f=${1%.bin}; out="${f}_'${head_sha_id}'.bin"; \
          echo -e "Source: '${YELLOW}'${f}'${NC}'"; \
          echo -e "Output: '${LRED}'${out}'${NC}'"; \
          cp "${1}" "${out}"' None {} \;
else
    echo "Error: bin file not exists"
    exit 1
fi

exit 0
