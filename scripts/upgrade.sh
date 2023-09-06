#!/bin/bash

main(){
    # The function which runs the entire script.

    # Calling the upgrade_apt function
    full_upgrade

    # Calling the refresh_snap function
    refresh_snap
    
    # Calling the update_flatpak function
    update_flatpak
}


full_upgrade(){
    # A function which updates and upgrades all the packages that are installed with apt package manager
    
    # Updating and upgrading the packages that are installed with apt package manager
    apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y

}

refresh_snap(){
    # A function which updates all the snap packages

    # Updating the packages that are installed with snap package manager
    snap refresh

}

update_flatpak(){
    # A function which updates the repository information for all installed remotes

    flatpak update

}

# Calling the main function.
main