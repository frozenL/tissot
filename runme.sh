#Setup env vars

if [ $(which adb) == "" ];
then
echo "adb not installed..."
echo "download adb and fastboot and install them to the /usr partition, if its in /home/ enter the path"
echo "enter path for ADB if its not in /usr/bin [enter to skip]"
read adb_path
echo $adb_path
postinstall=1
else
which adb
fi

if [ $(which fastboot) == "" ];
then
echo "fastboot not installed..."
echo "download adb and fastboot and install them to the /usr partition, if its in /home/ enter the path"
echo "enter path for fastboot if its not in /usr/bin [enter to skip]"
read fastboot_path
echo $fastboot_path
postinstall=1
else
which fastboot
fi

if [ $adb_path == ""];
then
echo "run script again after adb/fastboot installation"
else
  if [ $postinstall == 1];
  then
  echo "adb_binary='$adb_path'" >> ~/.bashrc
  echo "fastboot_binary='$fastboot_path'" >> ~/.bashrc
  fi
fi

echo "pre install finished"
