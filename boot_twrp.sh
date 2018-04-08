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

