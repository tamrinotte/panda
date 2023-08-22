#!/bin/bash

main() {
    # The function which runs the entire script

    # Calling the declare_variables function
    declare_variables

    # Calling the set_up_file_ownerships function
    set_up_file_ownerships
    
}

declare_variables() {
    # A function which declares variables

    # Creating a variable called username which is equal to the logged in user's username
    username=${SUDO_USER:-${USER}}

}

set_up_file_ownerships() {
    # A function which sets the file ownerships and permissions

    # Changing the file ownerships recursively
    chown -R $username:$username /opt/

    # Changing the launchers file ownership 
    chown $username:$username /usr/bin/panda

}

# Calling the main function
main
