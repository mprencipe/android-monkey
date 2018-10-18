#!/bin/sh
seed=$(date +%%s%%N)
events=10000
devices=$(adb devices|tail +2|cut -f1)
user='someuser'
pass='somepass'

pull_window_dump() {
  device=$1
  adb -s $device shell uiautomator dump
  adb -s $device pull /sdcard/window_dump.xml /tmp/$device.xml
}

click_by_attribute() {
  attribute=$1
  device=$2
  pull_window_dump $device
  bounds=$(xmllint --xpath "//node[@resource-id='$attribute']/@bounds" /tmp/$device.xml|xargs|awk -F '[][]' '{print $2}')
  x=$(echo $bounds|awk -F ',' '{print $1}')
  y=$(echo $bounds|awk -F ',' '{print $2}')
  adb -s $device shell input tap $x $y
}

for device in $devices
do
  adb -s $device shell monkey -p your.app.package.debug -c android.intent.category.LAUNCHER 1
  sleep 1

  # enable if you need to grant a permission
  # click_by_attribute 'com.android.packageinstaller:id/permission_allow_button' $device

  click_by_attribute 'your.app.package.debug:id/username_edit' $device
  adb -s $device shell input text $user

  click_by_attribute 'your.app.package.debug:id/password_edit' $device
  adb -s $device shell input text $pass

  click_by_attribute 'your.app.package.debug:id/login_button' $device
  
  sleep 5
  adb -s $device shell monkey -p your.app.package.debug -v --pct-syskeys 0 $events
done
