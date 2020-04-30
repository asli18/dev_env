#!/bin/bash

<< README
Load FW to device via Xmodem

$ sudo kermit; Ctrl-\
$ source load_fw.sh
README

if [ $# -eq 2 ]; then
    dev=${1}
    img=${2}
    echo -e "Xmodem send ${GREEN}${img}${NC} to ${CYAN}${dev}${NC}"
else
    echo -e "Invalid input"
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


