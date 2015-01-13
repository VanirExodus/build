#!/bin/bash

function countdown
{
    local OLD_IFS="${IFS}"
    IFS=":"
    local ARR=( $1 )
    local SECONDS=$((  (ARR[0] * 60 * 60) + (ARR[1] * 60) + ARR[2]  ))
    local START=$(date +%s)
    local END=$((START + SECONDS))
    local CUR=$START

    while [[ $CUR -lt $END ]]
        do
            CUR=$(date +%s)
            LEFT=$((END-CUR))
            printf "\r%02d:%02d:%02d" \
                   $((LEFT/3600)) $(( (LEFT/60)%60)) $((LEFT%60))
            sleep 1
        done

    IFS="${OLD_IFS}"
    echo "        "
}

# Variables
DEVICE=$1
TARGET_PRODUCT=$2
T=$PWD
OUT=$T/out/target/product/$DEVICE
MODVERSION=`sed -n -e'/ro\.modversion/s/^.*=//p' $OUT/system/build.prop`
OUTVERSION="exodus-$TARGET_PRODUCT"_"$MODVERSION.zip"

if [ -z "$OUT" -o ! -d "$OUT" ]; then
    echo -e $CL_RED"ERROR: $0 only works with a full build environment. $OUT should exist."$CL_RST
    exit 1
fi

if [ -f $OUT/$OUTVERSION ]; then
    echo "AUTOFLASHING THE ROM..."
    echo "hit control-c to cancel"
    echo ""
    echo "rebooting in"
    countdown "00:00:05"
fi

adb shell "echo 'boot-recovery ' > /cache/recovery/command"
adb shell "echo '--update_package=SDCARD:$OUTVERSION' >> /cache/recovery/command"
adb shell "echo 'reboot' >> /cache/recovery/command"

adb push $OUT/$OUTVERSION /sdcard/$OUTVERSION && adb shell "reboot recovery"




