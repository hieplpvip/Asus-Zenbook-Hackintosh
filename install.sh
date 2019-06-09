#!/bin/bash

if [ "$(id -u)" != "0" ] && [ "$(sudo -n echo 'sudo' 2> /dev/null)" != "sudo" ]; then
    echo "This script must be run as root!"
    sudo $0 $@
    exit 0
fi

. ./src/config.txt

echo -e "\033[7m"
echo "------------------------------------------------------------"
echo "|           ASUS ZENBOOK HACKINTOSH by hieplpvip           |"
echo "|                    INSTALLATION SCRIPT                   |"
echo "|  A great amount of effort has been put in this project.  |"
echo "|     Please consider donating me at paypal.me/lebhiep     |"
echo "------------------------------------------------------------"
echo -e "\033[0m"
echo

PS3='Select model: '
select opt in "${MODELS[@]}"
do
    for i in "${!MODELS[@]}"; do
        if [[ "${MODELS[$i]}" = "${opt}" ]]; then
            model=$i
            break 2
        fi
    done
    echo Invalid
    echo
done
echo

#PS3='READ: allows apps like HWMonitor and iStat Menus to read CPU Fan Speed'$'\n''MOD: READ + custom fan control (quietest yet coolest)'$'\n''Select CPU Fan mode: '
#options=("READ" "MOD")
#select opt in "${options[@]}"
#do
#    case $opt in
#        "READ")
#            fan=0
#            break;;
#        "MOD")
#            fan=1
#            break;;
#        *)
#            echo Invalid
#            echo;;
#    esac
#done
#echo

sudo ./install_config.sh $model
echo
sudo ./install_acpi.sh $model
echo
sudo ./install_downloads.sh $model
