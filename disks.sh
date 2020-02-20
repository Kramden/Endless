#!/bin/bash

if [ `whoami` != "root" ];
then
  echo "Please run as root"
  echo "usage: sudo ./disks.sh"
  exit
fi

# Iterate disks looking for usb sticks
for disk in /dev/sd[a-z] /dev/sd[a-z][a-z]; do
  if test -b $disk; then
    #echo; echo ------------------ Disk $disk ------------------
    udisksctl info -b $disk > /dev/null
    for partition in $disk[1-9] $disk[0-9][0-9]; do
      if test -b $partition; then
        #echo; echo ------------------ Partition $partition ------------------
        udisksctl info -b $partition | grep HintIgnore | grep false > /dev/null
        if [ $? -eq 0 ];
        then
          #udisksctl info -b $partition | grep vfat > /dev/null
          udisksctl info -b $partition | grep HintSystem | grep false > /dev/null
          if [ $? -eq 0 ];
          then
              echo "New USB Stick detected"
              echo "$partition will be erased, please confirm with yes or no"
              read response
              if [ "$response" == "yes" ];
              then
                 umount $partition
                 sync
                 mkfs.ext4 -E lazy_itable_init $partition
                 sync
                 udisksctl mount -b $partition > /dev/null
                 sync
                 m=`udisksctl info -b $partition | grep MountPoints | awk {'print $2'}`
                 sleep 5
                 cp -rp $PWD/usbstick/* $m/
                 cp -rp $PWD/export/.ostree $m/
              fi
          fi
        fi
      fi
    done
  fi
done
