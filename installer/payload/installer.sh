#!/bin/bash
#V A add in chmod scratch_gpio.sh
#Version B � go back to installing deb gpio package directly
#Version C � install sb files into /home/pi/Documents/Scratch Projects
#Version D � create �/home/pi/Documents/Scratch Projects� if it doesn�t exist
#Version E � change permissions on �/home/pi/Documents/Scratch Projects�
#Version F 13Oct12 � rem out rpi.gpio as now included in Raspbian
#Version G 20Mar13 - Allow otheruser option on commandline (Tnever/meltwater)
#Version H 24Mar13 - correct newline issues
#Version 1.1 5Dec13 - make all files be owned by normal user
#V1.2 16jan14 - create autostart dir if not existing
f_exit(){
echo ""
echo "Usage:"
echo "i.e. sudo install_sid.sh otheruser"
echo "Optional: Add a non-default 'otheruser' username after the command (default is:pi)."
exit
}

echo "Running Installer"
if [ -z $1 ]
then
HDIR="/home/pi"
USERID="pi"
GROUPID="pi"
else
HDIR=/home/$1
USERID=`id -n -u $1`
GROUPID=`id -n -g $1`
fi

#Confirm if install should continue with default PI user or inform about commandline option.
echo ""
echo "Install Details:"
echo "Home Directory: "$HDIR
echo "User: "$USERID
echo "Group: "$USERID
echo ""
if [ ! -d "$HDIR" ]; then
    echo ""; echo "The home directory does not exist!";f_exit;
fi

sudo rm -rf $HDIR/sid
mkdir -p $HDIR/sid
chown -R $USERID:$GROUPID $HDIR/sid


cp sid.py $HDIR/sid

#Instead of copying the sid.sh file, we will generate it
#Create a new file for sid.sh
echo "#!/bin/bash" > $HDIR/sid/sid.sh
echo "#Version 0.2 - add in & to allow simulatenous running of handler and Scratch" >> $HDIR/sid/sid.sh
echo "#Version 0.3 - change sp launches rsc.sb from \"/home/pi/Documents/Scratch Projects\"" >> $HDIR/sid/sid.sh
echo "#Version 0.4 - 20Mar13 meltwater - change to use provided name for home" >> $HDIR/sid/sid.sh
echo "#V0.5 re-used for launching sid.py" >> $HDIR/sid/sid.sh
echo "sudo pkill -f sid.py" >> $HDIR/sid/sid.sh
echo "sudo python /home/pi/sid/sid.py" >> $HDIR/sid/sid.sh

chown -R $USERID:$GROUPID $HDIR/sid
chmod +x $HDIR/sid/sid.sh

mkdir -p $HDIR/.config
chown -R $USERID:$GROUPID $HDIR/.config

mkdir -p $HDIR/.config/autostart
chown -R $USERID:$GROUPID $HDIR/.config/autostart

rm -rf $HDIR/.config/autostart/sid.desktop
rm -rf $HDIR/Desktop/sid.desktop

cp sid.desktop $HDIR/Desktop
sudo chown $USERID:$GROUPID $HDIR/Desktop/sid.desktop
cp sid.desktop $HDIR/.config/autostart
sudo chown $USERID:$GROUPID $HDIR/.config/autostart/sid.desktop



echo ""
echo ""
echo "Finished installing Scratch Interface Device software"
