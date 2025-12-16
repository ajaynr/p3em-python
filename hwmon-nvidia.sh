#!/bin/bash

nvidia-smi -q -d POWER | grep -e Readi  -e Draw | \
awk 'BEGIN{i=97}(NR%2==1){prefix = "nvidia-smi_" $1"_"$2"_"}(NR%2!=1){value=$1" "$4+0"W"; printf("%c_", i++); print  prefix value }'

for x in {0..120}; do
  MPATH=/sys/class/hwmon/hwmon${x}/device/
#for MPATH in $( ls /sys/class/hwmon/hwmon*/device/ ); do
  if [ -f $MPATH/power1_oem_info ]; then
    if [ -f $MPATH/power1_average ]; then
      echo -n ${x}_$(cat $MPATH/power1_oem_info | awk '{print "hwmon_" $1 "_" $2"_Average"}')
      echo " " $(cat $MPATH/power1_average  | awk '{print ($1/1.0E6)}')W
    fi
    if [ -f $MPATH/power1_inst* ]; then
      echo -n ${x}_$(cat $MPATH/power1_oem_info | awk '{print "hwmon_" $1 "_"$2"_Instantaneous"}')
      echo " " $(cat $MPATH/power1_instant  | awk '{print ($1/1.0E6)}')W
    fi
  fi
done
