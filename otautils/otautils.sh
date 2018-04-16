# OTA Util main script
adb_binary="adb"
fastboot_binary="fastboot"
echo "  ___ _____  _      _   _ _____ ___ _     "
echo " / _ \_   _|/ \    | | | |_   _|_ _| |    "
echo "| | | || | / _ \   | | | | | |  | || |    "
echo "| |_| || |/ ___ \  | |_| | | |  | || |___ "
echo " \___/ |_/_/   \_\  \___/  |_| |___|_____|"
echo ""
echo ">> Enter option"
echo "  - 1: Extract OTA link from logcat"
echo "  - 2: Unpack images from payload.bin"
echo "  - 3: Flash images to device via $fastboot_binary"
echo "  - 4: Generate TWRP flashable zip"
echo "  - 0: Exit"
echo -ne ">> "; read choice
case $choice in
	1)
		echo ">> Check for updates now"
		$adb_binary devices
		echo -ne ">> Press enter to start logging"; read
		echo ">> Logging..."
		$adb_binary logcat | grep "packages/ota-api"	
		;;
	2)
		ls
		echo -ne "Enter OTA package path (if the package is in $(pwd | sed 's#.*/##') just input the filename): "; read otapackage
		mkdir images_dump
		python payload_dumper.py $otapackage
		mv *.img images_dump
		;;
	3) 
		if [[ $(find system.img) == "system.img" ]];
		then
		$adb_binary reboot bootloader
		echo -ne ">> press enter when device is in bootloader"; read
		$fastboot_binary oem unlock
		$fastboot_binary flash modem_a modem.img
		$fastboot_binary flash modem_b modem.img
		$fastboot_binary flash sbl1 sbl1.img
		$fastboot_binary flash sbl1bak sbl1.img
		$fastboot_binary flash rpm rpm.img
		$fastboot_binary flash rpmbak rpm.img
		$fastboot_binary flash tz tz.img
		$fastboot_binary flash tzbak tz.img
		$fastboot_binary flash devcfg devcfg.img
		$fastboot_binary flash devcfgbak devcfg.img
		$fastboot_binary flash dsp dsp.bin
		$fastboot_binary flash aboot aboot.img
		$fastboot_binary flash abootbak aboot.img
		$fastboot_binary flash boot_a boot.img
		$fastboot_binary flash boot_b boot.img
		$fastboot_binary flash system_a system.img
		$fastboot_binary flash system_b system.img
		$fastboot_binary flash lksecapp lksecapp.img
		$fastboot_binary flash lksecappbak lksecapp.img
		$fastboot_binary flash cmnlib cmnlib.img
		$fastboot_binary flash cmnlibbak cmnlib.img
		$fastboot_binary flash cmnlib64 cmnlib64.img
		$fastboot_binary flash cmnlib64bak cmnlib64.img
		$fastboot_binary flash keymaster keymaster.img
		$fastboot_binary flash keymasterbak keymaster.img
		$fastboot_binary reboot bootloader
		sleep 5
		$fastboot_binary set_active a
		$fastboot_binary oem lock
		$fastboot_binary reboot
		else
		echo ">> cd into the images directory and run again"
		exit
		fi
		;;
	4)
		if [ -d "META-INF" ];
		then
			if [ -d "images_dump" ];
			then
				cp META-INF images_dump/
				cd images_dump
				zip -r ../update.zip .
				echo ">> done"
			else
				echo ">> image dump folder not found, make sure there is a folder called images_dump with the system images and run again."
				exit
			fi
		else
			echo ">> META-INF folder not found, run script from tissot/otautils"
			echo ">> image dump folder not found, make sure there is a folder called images_dump with the system images and run again."
			exit
		fi
		;;
	0)
		exit
		;;
esac
