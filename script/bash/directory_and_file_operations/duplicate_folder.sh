#!/bin/bash

<< README
Create duplicate folders of an existing folder and name them in sequence.

$ ./duplicate_folder.sh <input_folder_path> <output_folder_path> <copy_num>

Ex:
$ ./duplicate_folder.sh foo . 3
foo_1
foo_2
foo_3
README

LRED='\e[91m'
YELLOW='\e[33m'
NC='\e[0m'

if [ $# -eq 3 ]; then
    input_folder_path=${1}
    output_folder_path=${2}
    copy_num=${3}

    #echo $input_folder_path
    #echo `dirname $input_folder_path`
    #echo `basename $input_folder_path`
    #echo `dirname $input_folder_path`/`basename $input_folder_path`

    # -d: directory exists
    if [ ! -d "${output_folder_path}" ]; then
        echo -e "${YELLOW}Output Folder:${NC}" \
                "${LRED}${output_folder_path}${NC} not exists," \
                "abort process"
        exit 1
    fi

    for i in $(seq 1 1 ${copy_num});
    do
        output="${output_folder_path}/`basename ${input_folder_path}`_${i}"

        if [ -d "${output}" ]; then
            echo -e "${YELLOW}Intput Folder:${NC}" \
                    "${LRED}${output}${NC} exists," \
                    "abort process"
            exit 1
        fi

        cp -r "${input_folder_path}" "${output}"
        echo "${output}"
    done
else
    echo -e "Invalid input," \
            "./duplicate_folder.sh <input_folder_path> <output_folder_path> <copy_num>"
    exit 1
fi

exit 0

