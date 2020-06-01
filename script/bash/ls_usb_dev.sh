#!/bin/bash

<<README
List the dev path for each device.

    Looking for USB devices with a ID_SERIAL attribute.
    Typically only real USB devices will have this attribute.

    Results might look like this:
    /dev/ttyACM0 - LG_Electronics_Inc._LGE_Android_Phone_VS930_4G-991c470
    /dev/sdb - Lexar_USB_Flash_Drive_AA26MYU15PJ5QFCL-0:0
    /dev/sdb1 - Lexar_USB_Flash_Drive_AA26MYU15PJ5QFCL-0:0
    /dev/input/event5 - Logitech_USB_Receiver
    /dev/input/mouse1 - Logitech_USB_Receiver
    /dev/input/event2 - Razer_Razer_Diamondback_3G
    /dev/input/mouse0 - Razer_Razer_Diamondback_3G
    /dev/input/event3 - Logitech_HID_compliant_keyboard
    /dev/input/event4 - Logitech_HID_compliant_keyboard

ref: https://unix.stackexchange.com/questions/144029/command-to-determine-ports-of-a-device-like-dev-ttyusb0?newreg=dc1a17edb8bd4f268530b64bbd48af60
README

for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do
    (
        syspath="${sysdevpath%/dev}"
        devname="$(udevadm info -q name -p $syspath)"
        [[ "$devname" == "bus/"* ]] && exit
        eval "$(udevadm info -q property --export -p $syspath)"
        [[ -z "$ID_SERIAL" ]] && exit
        echo "/dev/$devname - $ID_SERIAL"
    )
done
