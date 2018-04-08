# G-Cam pre install script
# src: https://forum.xda-developers.com/showpost.php?p=75541654&postcount=98
# gcam binary: https://www.celsoazevedo.com/files/android/google-camera/
#adb_binary="adb"
#fastboot_binary="fastboot"

if [ "$1" == "install" ];
then
echo "installing gcam apk"
wget https://www.celsoazevedo.com/files/android/google-camera/f/GoogleCamera-Pixel2Mod-Arnova8G2-V6.apk
$adb_binary install GoogleCamera-Pixel2Mod-Arnova8G2-V6.apk
echo "done."
fi

if [ "$1" == "" ];
then
echo "Rootless EIS+HAL 3 enabler"
sleep 1
echo "Plug in your device"
echo "and make sure adb debugging is enabled"
sleep 1
$adb_binary reboot bootloader
sleep 5
$fastboot_binary oem unlock
$fastboot_binary boot twrp.img
echo "booted to TWRP temporarily"
echo -ne "Type enter when TWRP is booted and ready..."; read
$adb_binary shell "setprop persist.camera.HAL3.enabled 1"
$adb_binary shell "setprop persist.camera.eis.enable 1"
echo "eis + hal3 enabled"
$adb_binary reboot bootloader
sleep 5
$fastboot_binary oem lock
$fastboot_binary reboot
echo "g-cam pre setup complete, run $0 install to install the latest APK"
fi
