./boot_twrp.sh
echo -ne "add more volume/call steps? [Y/N]: "; read choice
if [ $choice == "Y"];
then
echo -ne "call volume steps integer: "; read call_vol
echo -ne "media volume steps integer: "; read media_vol
sleep 1
$adb_binary shell setprop ro.config.vc_call_vol_steps $call_vol
$adb_binary shell setprop ro.config.media_vol_steps $media_vol
$adb_binary shell "setprop audio.safemedia.bypass true"
fi

echo -ne "add sw navbar ? [Y/N]: "; read choice
if [ $choice == "Y"];
then
$adb_binary shell "setprop qemu.hw.mainkeys 0"
fi

$adb_binary reboot
