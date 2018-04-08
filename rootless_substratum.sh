#Credit: https://forum.xda-developers.com/apps/substratum/andromeda-desktop-clients-release-notes-t3668682 
#Make sure you have Andromeda installed
$adb_binary kill-server
$adb_binary start-server

# Device configuration of the testing rack

# Let's first grab the location where Andromeda is installed
pkg=$($adb_binary shell pm path projekt.andromeda)
echo "$pkg"

# Due to the way the output is formatted, we have to strip 10 chars at the start
pkg=$(echo $pkg | cut -d : -f 2 | sed s/\\r//g)

# Now let's kill the running Andromeda services on the mobile device
kill=$($adb_binary shell pidof andromeda)

# Check if we need to kill the existing pids, then kill them if need be
if [[ "$kill" == "" ]]
then echo
$adb_binary shell << EOF
am force-stop projekt.substratum
appops set projekt.andromeda RUN_IN_BACKGROUND allow
appops set projekt.substratum RUN_IN_BACKGROUND allow
CLASSPATH=$pkg app_process /system/bin --nice-name=andromeda projekt.andromeda.Andromeda &
echo "You can now remove your device from the computer!"
exit
EOF
else echo
$adb_binary shell << EOF
am force-stop projekt.substratum
kill -9 $kill
appops set projekt.andromeda RUN_IN_BACKGROUND allow
appops set projekt.substratum RUN_IN_BACKGROUND allow
CLASSPATH=$pkg app_process /system/bin --nice-name=andromeda projekt.andromeda.Andromeda &
echo "You can now remove your device from the computer!"
exit
EOF
fi

# We're done!
$adb_binary kill-server
