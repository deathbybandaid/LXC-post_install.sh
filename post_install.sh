#!/bin/sh
####################################################################################
##          This is The Deathbybandaid Post Install for debian/ubuntu LXC         ##
####################################################################################


# Update Container
echo "Running Updates"
apt-get update -qq && apt-get upgrade -qq
echo "Updates installed"
echo

## Simple test if Whiptail is installed for dialogue boxes.
if which whiptail >/dev/null;
  then
    :
  else
    apt-get install -y whiptail
fi

# Apt-Cacher-NG
if  (whiptail --title "Apt-Cacher-NG" --yes-button "Proceed" --no-button "Skip" --yesno "Connect to an apt cache?" 10 80)
  then
    APTPROXYIP="192.168.2.50"
    APTPROXYIP=$(whiptail --inputbox "Please enter apt cache address without protocol or port" 10 80 "$APTPROXYIP" 3>&1 1>&2 2>&3)
    APTPROXYPORT="3142"
    APTPROXYPORT=$(whiptail --inputbox "Please enter apt cache port" 10 80 "$APTPROXYPORT" 3>&1 1>&2 2>&3)
    APTPROXYFILE="/etc/apt/apt.conf.d/00aptproxy"
    echo "Setting up apt-cache proxy in $APTPROXYFILE for http://$APTPROXYIP:$APTPROXYPORT"
    echo
    echo "Acquire::http::Proxy \"http://$APTPROXYIP:$APTPROXYPORT\";" > /etc/apt/apt.conf.d/00aptproxy 2> /dev/null
    echo "Proxy installed"
    echo
fi

# install sudo
echo "Installing sudo"
apt install -qq -y sudo
echo "sudo installed"
echo

# install basic key management
echo "installing key management"
apt install -qq -y software-properties-common gpg dirmngr
echo "key management installed"
echo

# setup sysop user
SUDOUSERNAME="sysop"
SUDOUSERNAME=$(whiptail --inputbox "Please enter a username" 10 80 "$SUDOUSERNAME" 3>&1 1>&2 2>&3)
SUDOUSERTEMPPASS=$(whiptail --inputbox "Please enter a password" 10 80 "$SUDOUSERNAME" 3>&1 1>&2 2>&3)
echo "setting up sudo user $SUDOUSERNAME"
if getent passwd $SUDOUSERNAME > /dev/null 2>&1
  then
    echo "user $SUDOUSERNAME exists"
  else
    useradd -m -s /bin/bash -p $SUDOUSERTEMPPASS $SUDOUSERNAME
fi

usermod -aG sudo $SUDOUSERNAME

if grep -q $SUDOUSERNAME "/etc/sudoers"
  then
    echo "$SUDOUSERNAME already in sudoers file"
  else
    echo "$SUDOUSERNAME    ALL=(ALL:ALL) ALL" >> /etc/sudoers /dev/null 2>&1
fi
echo "sudo user setup complete for $SUDOUSERNAME"
echo
