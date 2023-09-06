#!/usr/bin/bash

# Purge the app
echo "Purging panda..."
sudo apt purge --autoremove panda -y

# Remove whats left as well
echo "Deleting what is left..."
sudo rm -rf /opt/panda

# Creating a variable called username by getting the active user's username
username=${SUDO_USER:-${USER}}

# Delete the old files if they are exist
echo "Deleting the dist folder..."
if [[ -d dist/ ]]; then
    rm -rf dist/
fi

echo "Deleting the build folder..."
if [[ -d build/ ]]; then
    rm -rf build/
fi 

echo "Deleting the package folder..."
if [[ -d package/ ]]; then
    rm -rf package/
fi

echo "Deleting the installer..."
if [[ -f panda.deb ]]; then
    rm panda.deb
fi 

# Create the executable file
echo 'Creating the executable file...'
pyinstaller --onefile panda.py --name="panda"

# Create a directory hierarchy to package your application
echo 'Creating the directory hierarchy...'
mkdir -p package/opt/panda
mkdir -p package/usr/bin

# Copy required files and folders into the package
echo 'Copying the executable file into package/usr/bin'
cp -r dist/panda package/usr/bin

echo 'Copying scripts into opt'
cp -r scripts package/opt/panda

echo 'Copying app lists into opt'
cp -r app_lists package/opt/panda

echo 'Copying configuration files into opt'
cp -r configuration_files package/opt/panda

# Set the permissions and file ownerships
echo 'Setting the file permissions and ownerships'
chmod 755 -R package/
chown $username:$username -R package/

# Create the installer
echo 'Creating the installer...'
fpm -C package -s dir -t deb -n "panda" -v 0.1.0 -p panda.deb

# Start the installer
sudo dpkg -i panda.deb