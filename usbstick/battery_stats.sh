#!/bin/bash

count=0
aggregate_capacity=0
for dev in `upower -e`;
do
  nativepath=`gdbus call --system --dest=org.freedesktop.UPower --object-path=$dev --method=org.freedesktop.DBus.Properties.Get org.freedesktop.UPower.Device NativePath|sed -e 's/(<//g'|sed -e 's/>,)//g'`
  capacity=$(gdbus call --system --dest=org.freedesktop.UPower --object-path=$dev --method=org.freedesktop.DBus.Properties.Get org.freedesktop.UPower.Device Capacity|sed -e 's/(<//g'|sed -e 's/>,)//g')
  type=`gdbus call --system --dest=org.freedesktop.UPower --object-path=$dev --method=org.freedesktop.DBus.Properties.Get org.freedesktop.UPower.Device Type|sed -e 's/(<uint32 //g'|sed -e 's/>,)//g'`
  powersupply=`gdbus call --system --dest=org.freedesktop.UPower --object-path=$dev --method=org.freedesktop.DBus.Properties.Get org.freedesktop.UPower.Device PowerSupply|sed -e 's/(<//g'|sed -e 's/>,)//g'`
  full=`gdbus call --system --dest=org.freedesktop.UPower --object-path=$dev --method=org.freedesktop.DBus.Properties.Get org.freedesktop.UPower.Device EnergyFull|sed -e 's/(<//g'|sed -e 's/>,)//g'`
  design=`gdbus call --system --dest=org.freedesktop.UPower --object-path=$dev --method=org.freedesktop.DBus.Properties.Get org.freedesktop.UPower.Device EnergyFullDesign|sed -e 's/(<//g'|sed -e 's/>,)//g'`

  capacity_int=${capacity%.*}
  design_int=${design%.*}

  if [ $powersupply == "true" ] && [ $type == 2 ] && [ $capacity_int -gt 0 ] && [ $design_int -gt 0 ];
  then
    echo "NativePath: "$nativepath
    echo "Design: "$design
    echo "Actual: "$full
    echo "Capacity: "$capacity
    count=$((count + 1))
    aggregate_capacity=$((aggregate_capacity + $capacity_int))
  fi
done

echo " "
echo " "
echo "Number of devices: "$count
echo "Average capacity: "$((aggregate_capacity/2))
