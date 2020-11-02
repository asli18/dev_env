#!/bin/bash

<< README
Send image file over serial port with XMODEM protocol

README

# Detect if a script is being sourced or executed
shopt -s expand_aliases # make alias command work in bash script
[[ $0 != $BASH_SOURCE ]] && alias exit_cmd='return' || alias exit_cmd='exit'

usage() {
    echo "Usage: ./load_img.sh [image_path] [dev]"
    echo "Send image file over serial port with XMODEM protocol"
    echo ""
    echo "example:"
    echo "  $ ./load_img.sh foo.bin /dev/ttyUSB0"
    echo "  $ source load_img.sh foo.bin /dev/ttyUSB0"
    echo "  $ . load_img.sh foo.bin /dev/ttyUSB0"
}

if [ $# -eq 2 ]; then
    img=${1}
    dev=${2}

    if [ ! -e ${dev} ]; then
        echo -e "${CYAN}${dev}${NC} does not exist"
        exit_cmd 1
    fi

    echo -e "Xmodem send ${GREEN}${img}${NC} to ${CYAN}${dev}${NC}"
else
    echo -e "Invalid input \"${1}\"\n"
    usage
    exit_cmd 1
fi

sudo chmod o+rw ${dev}

#stty -F /dev/ttyUSB0 115200 && sed '/setup done/q' < /dev/ttyUSB0
#stty -F /dev/ttyUSB0 115200

echo -en "\r\n\r\nxr\r\n" > ${dev}

sudo sx -vv -t 10 -T "${img}" > ${dev} < ${dev}

if [ $? -eq 0 ]; then
    echo "Done"
    #cat ${dev}
    timeout 3 sed '/load code done/q' < ${dev} # parsing end string, timeout 3s
else
    echo "Fail"
fi

echo -en "\r\n\r\n" > ${dev}

unset -f usage

exit_cmd 0

