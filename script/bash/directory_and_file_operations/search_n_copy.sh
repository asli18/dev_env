#!/bin/bash

<< README
Search file, Copy and Rename them to the new folder

$ ./search_n_copy.sh <input_folder_path> <file_name> [<output_folder_name>]
README

LRED='\e[91m'
YELLOW='\e[33m'
NC='\e[0m'


if [ $# -ge 2 ]; then
    input_folder_path=${1}
    file_name=${2}
    output_folder_name=""

    if [ $# -eq 3 ]; then
        output_folder_name=${3}

        if [ -d "./${output_folder_name}" ]; then
            echo "Create folder fail"
            echo -e "${YELLOW}Folder${NC} ${LRED}${output_folder_name}${NC}" \
                    "exists, abort process"
            exit 1
        fi
    else
        folder_prefix="result"
        output_folder_name=${folder_prefix}
        counter_start=0001
        counter_max=1000

        # === Check if folder exists "result_[0001 - 1000]" ===
        # seq -w does automatically add zero-padding of the output numbers based on
        # the widest number generated.
        #for i in $(seq -w 1 1 ${counter_max});
        for i in $(seq -f "%04g" ${counter_start} 1 ${counter_max});
        do
            # -d: directory exists
            if [ ! -d "./${output_folder_name}_${i}" ]; then
                output_folder_name=${output_folder_name}_${i}
                break
            fi
        done

        if [[ ${output_folder_name} == ${folder_prefix} ]]; then
            echo "Create folder fail"
            echo -e "${YELLOW}Folder${NC}" \
                    "${LRED}${output_folder_name}_${counter_start}${NC} to ${LRED}${i}${NC}" \
                    "all exists, abort process"
            exit 1
        fi

    fi

    # Output path
    echo -e "Create folder ${LRED}${output_folder_name}${NC}"
    mkdir ${output_folder_name}

    find_num=$(find ${input_folder_path} -type f -name "${file_name}" -printf '.' | wc -c)
    echo -e "Total ${YELLOW}${find_num}${NC} files"

    # Find files, Create duplicate files and add prefix string to filename with file path
    #     ${1#./} is an example of bash's prefix removal.
    #             It returns the strign $1 with './' removed from the beginning.
    #             ('%': suffix removal)
    #     ${f//\//_} is an example of bash's pattern substitution.
    #                It returns the string $f with all '/' replaced with '_'.
    # To read more about these features, see the section in man bash entitled Parameter Expansion.
    find ${input_folder_path} -type f -name "${file_name}" \
         -exec bash -c 'pre='"${input_folder_path}/"'; f=${1#"$pre"}; \
                        out=./'${output_folder_name}'/"${f//\//_}"; cp "${1}" "${out}";
                        echo ${out};' None {} \;

else
    echo -e "Invalid input:"
    echo -e "./search_n_copy.sh <input_folder_path> <file_name> [<output_folder_name>]"
    exit 1
fi

exit 0

