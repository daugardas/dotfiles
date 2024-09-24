#!/bin/bash

# check sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

sof_bin_release_temp_dir="/tmp/sof-bin-release"

echo "Checking if '$sof_bin_release_temp_dir' directory is available in $sof_bin_release_temp_dir"

if [ -d $sof_bin_release_temp_dir ]; then
    echo "Removing '$sof_bin_release_temp_dir' directory"
    rm -rf $sof_bin_release_temp_dir
fi

echo "Creating '$sof_bin_release_temp_dir' directory"

mkdir $sof_bin_release_temp_dir

echo "Changing directory to '$sof_bin_release_temp_dir'"

cd $sof_bin_release_temp_dir

echo "Downloading latest sof-bin release from github"

# download latest sof-bin release from github https://github.com/thesofproject/sof-bin/releases/latest

sof_bin_release_file_url=$(curl -s https://api.github.com/repos/thesofproject/sof-bin/releases/latest | grep '"browser_download_url":' | grep 'tar.gz' |  grep -o 'https://[^"]*')

# exit if sof-bin release file url is not available

if [ -z $sof_bin_release_file_url ]; then
    echo "Failed to get latest sof-bin release file url"
    exit 1
fi

echo "Latest sof-bin release file url: $sof_bin_release_file_url"

echo "Downloading latest sof-bin release file to $sof_bin_release_temp_dir"

wget $sof_bin_release_file_url -P $sof_bin_release_temp_dir

sof_bin_release_file=$(ls $sof_bin_release_temp_dir)

echo "Extracting latest sof-bin release file"

tar zxf $sof_bin_release_file

sof_bin_release_dir=$(ls -d $sof_bin_release_temp_dir/* | grep -v $sof_bin_release_file)

echo "Latest sof-bin release directory: $sof_bin_release_dir"

# create backups

backups_directory_name="Backups"

echo "Checking if '$backups_directory_name' directory is available in $(cd ~; pwd;)"

# when script is run as sudo, ~ will be /root. Need to change to current user's home directory

user_home_dir=$(eval echo ~$SUDO_USER)

if [ ! -d ~/$backups_directory_name ]; then
    echo "Creating '$backups_directory_name' directory in $user_home_dir"
    mkdir ~/$backups_directory_name
fi

lib_firmware_intel_sof_files_directory="/lib/firmware/intel/"
lib_firmware_intel_sof_files_backup_directory="$user_home_dir/$backups_directory_name/lib_firmware_intel_sof_files_backup"
usr_local_bin_sof_files_directory="/usr/local/bin"
usr_local_bin_sof_files_backup_directory="$user_home_dir/$backups_directory_name/usr_local_bin_sof_files_backup"

echo "Checking if '$lib_firmware_intel_sof_files_directory' directory is available in $user_home_dir"

if [ -d $lib_firmware_intel_sof_files_directory ]; then
    echo "Creating '$lib_firmware_intel_sof_files_backup_directory' directory in $user_home_dir"
    mkdir -p $lib_firmware_intel_sof_files_backup_directory
    echo "Moving files from '$lib_firmware_intel_sof_files_directory' to '$lib_firmware_intel_sof_files_backup_directory'"
    mv $lib_firmware_intel_sof_files_directory/sof* $lib_firmware_intel_sof_files_backup_directory
fi

echo "Checking if '$usr_local_bin_sof_files_directory' directory is available in $user_home_dir"

if [ -d $usr_local_bin_sof_files_directory ]; then
    echo "Creating '$usr_local_bin_sof_files_backup_directory' directory in $user_home_dir"
    mkdir -p $usr_local_bin_sof_files_backup_directory
    echo "Moving files from '$usr_local_bin_sof_files_directory' to '$usr_local_bin_sof_files_backup_directory'"
    mv $usr_local_bin_sof_files_directory/sof-* $usr_local_bin_sof_files_backup_directory
fi


echo "Changing directory to $sof_bin_release_dir"

cd $sof_bin_release_dir

echo "running install.sh script"

./install.sh

echo "Removing $sof_bin_release_temp_dir directory"

rm -rf $sof_bin_release_temp_dir

echo "sof-bin installation completed successfully."

read -r -p "Reboot now? [y/N] " response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    reboot
fi

echo "Please reboot to apply changes"

exit 0