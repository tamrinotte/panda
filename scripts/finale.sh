#!/bin/bash

main() {
    # The function which runs the entire script.

    # Calling the declare_variables function
    declare_variables

    # Calling the enable_swap_file function.
    enable_swap_file

    # Calling the scan_ports function
    scan_ports
    
}

declare_variables() {
	# A function which declares variables.

    # Creating a path which leads to the swap file
	swap_file_path="/var/opt/pandaswap"

    # Creating a variable called amount_of_free_swap_space_data
	amount_of_free_swap_space_data=$(free -m | grep Swap:)

	# Creating a path which leads to the fstab file. Hint: fstab file is the file where you define the file systems that will be mount automatically.
	fstab_file_path="/etc/fstab"

}

enable_swap_file () {
	# A function which enables the swap area. Hint: Swap area is a type of file system which holds data when RAM is used up. It's preventing app crashes

	# Checking if myswap file is not exists
	if [[ ! -f "$swap_file_path" ]]; then

		# Creating a swap file
		dd if="/dev/zero" of="$swap_file_path" bs=1M count=16384

		# Setting up the linux swap area
		mkswap "$swap_file_path"

		# Enabling the swap 
		swapon "$swap_file_path"

		# Checking if the fstab file doesn't include the swap file specification string
		if [[ ! $(grep "$swap_file_path swap swap defaults 0 0" $fstab_file_path) ]]; then

			# Make the swap area permanent
			echo "$swap_file_path swap swap defaults 0 0" >> $fstab_file_path

		fi

	# Checking if myswap file is exists
	else
	
		# Creating an array called strarr by splitting the command's output with IFS delimiter.
		IFS=' ' read -a strarr <<< "$amount_of_free_swap_space_data"

		# Identifying the total swap size
		swap_size="${strarr[1]}"

		# Checking if total swap size is smaller than  10000 mega bytes 
		if [[ $swap_size < 10000 ]]; then 

			# Deleting the swap file
			rm "$swap_file_path"

			# Creating a new swap file
			dd if="/dev/zero" of="$swap_file_path" bs=1M count=16384

			# Setting up the linux swap area
			mkswap "$swap_file_path"

			# Enabling the swap 
			swapon "$swap_file_path"

			# Checking if file file specification is not already specified in the "/etc/fstab file"
			if [[ ! $(grep "$swap_file_path swap swap defaults 0 0" $fstab_file_path) ]]; then

				# Make the swap area permanent
				echo "$swap_file_path swap swap defaults 0 0" >> $fstab_file_path

			fi

		fi

	fi

}

scan_ports() {
    # A function which scan ports.

    # Creating a variable called ip_addr by getting the local ip address from the sytem.
    ip_addr=$(hostname -I | awk '{print $1}')

    # Scanning all the TCP and UDP ports for service and operating system versions, scripts and traceroutes 
    nmap -sT -sU -sV -sC -A -p- "$ip_addr"

}


# Calling the main function
main