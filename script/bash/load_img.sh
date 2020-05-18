#!/bin/bash

<< README
Load Image file to device via Xmodem

$ sudo kermit; Ctrl-\
$ source load_img.sh <image_path> <dev>
README

if [ $# -eq 2 ]; then
    img=${1}
    dev=${2}

    if [ ! -e ${dev} ]; then
        echo -e "${CYAN}${dev}${NC} does not exist"
        return 1
    fi

    echo -e "Xmodem send ${GREEN}${img}${NC} to ${CYAN}${dev}${NC}"
else
    echo -e "Invalid input, source load_img.sh <image_path> <dev>"
    return 1
fi

sudo chmod o+rw ${dev}

#stty -F /dev/ttyUSB0 115200 && sed '/setup done/q' < /dev/ttyUSB0
#stty -F /dev/ttyUSB0 115200

echo -en "\r\n\r\nxr\r\n" > ${dev}

sudo sx -vv -t 10 -T "${img}" > ${dev} < ${dev}

if [ $? -eq 0 ]; then
    echo "Done"
    #cat ${dev}
    sed '/load code done/q' < ${dev} # parsing end string
else
    echo "Fail"
fi

echo -en "\r\n\r\n" > ${dev}


