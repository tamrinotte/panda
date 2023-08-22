#!/bin/bash

main() {
    # The function which runs the entire script.

    # Calling the declare_variables function.
    declare_variables

    # Calling the change_mac_address function.
    change_mac_address

    # Restarting the NetworkManager.service
    systemctl restart NetworkManager.service

    # Telling the computer to wait for 4 seconds.
    sleep 4

}

declare_variables() {
    # A function which declares variables

    # Creating a list of network interfaces
    list_of_network_interfaces=$(ip -o link show | awk -F': ' '{print $2}')

}

generate_random_mac() {

    printf "%02x:%02x:%02x:%02x:%02x:%02x\n" \
        $((RANDOM & 0xFE | 0x02)) \
        $((RANDOM & 0xFF)) $((RANDOM & 0xFF)) \
        $((RANDOM & 0xFF)) $((RANDOM & 0xFF)) $((RANDOM & 0xFF))

}

change_mac_address() {
    # A function which changes the mac address and reconnects to the internet

    # Iterating over each interface in the list_of_network_interfaces
    for interface in $list_of_network_interfaces; do

		# Checking if the interface is not the loop back interface
        if [[ $interface != "lo" ]]; then

			# Create a random mac address
			random_mac_address=$(generate_random_mac)

			# Display which interface's mac address changed to what
			echo "Changing MAC address for interface $interface to $random_mac_address"

			# Bringing the interface down
			ip link set dev $interface down

			# Stopping the NetworkManager service
			systemctl stop NetworkManager.service

			# Changing MAC address
			ip link set dev $interface address $random_mac_address

			# Starting the NetworkManager service
			systemctl start NetworkManager.service

			# Bringing the interface up
			ip link set dev $interface up

		fi

    done

}

# Executing the main function.
main
