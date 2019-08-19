# Apt-cache Vars
APTPROXYIP="192.168.2.50"
APTPROXYPORT="3142"
APTPROXYFILE="/etc/apt/apt.conf.d/00aptproxy"

# sudo user vars
SUDOUSERNAME="sysop"
SUDOUSERTEMPPASS=""


echo
echo

# Apt-Cacher-NG
echo "Setting up apt-cache proxy in $APTPROXYFILE for http://$APTPROXYIP:$APTPROXYPORT"
echo
echo "Acquire::http::Proxy \"http://$APTPROXYIP:$APTPROXYPORT\";" > /etc/apt/apt.conf.d/00aptproxy 2> /dev/null
echo "Proxy installed"
echo
echo


# Update Container
echo "Running Updates"
apt-get update -qq && apt-get upgrade -qq
echo "Updates installed"
echo
echo

# install sudo
echo "Installing sudo"
apt install -qq -y sudo
echo "sudo installed"
echo
echo

# install basic key management
echo "installing key management"
apt install -qq -y software-properties-common
apt install -qq -y gpg
apt install -qq -y dirmngr
echo "key management installed"
echo
echo

# setup sysop user
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
echo

