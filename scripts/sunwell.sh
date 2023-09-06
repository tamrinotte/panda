#!/bin/bash

main() {
    # The function which runs the entire program.

    # Calling the declare_variables function.
    declare_variables

    # Calling the install_softwares_from_sources function.
    install_softwares_from_sources

    # Calling the install_softwares_with_flatpak function.
    install_softwares_with_flatpak

    # Calling the install_softwares_with_snap function
    install_softwares_with_snap
    
    # Calling the install_softwares_from_github function.
    install_softwares_from_github

}

declare_variables() {
    # A function which declares variables.

    sources_list_file_path="/opt/panda/app_lists/sources.list"

    github_list_file_path="/opt/panda/app_lists/github.list"

    flathub_list_file_path="/opt/panda/app_lists/flathub.list"

    snap_store_list_file_path="/opt/panda/app_lists/snap_store.list"

}

install_softwares_from_sources() {
    # A function which installs softwares from sources.list using the apt package manager.

    # Telling to the user what's happening
    echo "Installing the softwares from sources.list file"

    # Looping through each line in the app.list file.
    for app in $(cat $sources_list_file_path);do

        # Checking if the software which is written in the line is not installed.
        if [[ $(apt policy "$app" 2>/dev/null) == *"(none)"* ]]; then

            # Installing the software which is written in the line.
            apt install $app -yy;

            # Continuing looping after installation.
            continue

        # Checking if the software which is written in the line is installed.
        else

            # Telling to user that the software is already installed.
            echo "$app is already installed";

        fi
        
    done

}

install_softwares_from_github() {
    # A function which downloads and installs softwares from github using dpkg package manager

    # Telling to the user what's happening
    echo "Installing the softwares from github with dpkg package manager"

    # Iterating over each url in the list_of_urls
    for url in $(cat $github_list_file_path);do

        # Creating an array from the url by spliting it with the delimeter.
        IFS='/' read -a strarr <<< "$url";

        # Calculating the length of the array
        length_of_the_array="${#strarr[@]}";

        # Calculating the target's index number
        target_index=$(($length_of_the_array-1));

        # Creating a variable called installer_name
        installer_name=${strarr[$target_index]}

        # Creating a variable to store the application's name
        app_name=${installer_name:0:$((${#installer_name}-4))}

        # Changing the current working directory to opt
        cd /opt
    
        # Checking if the installer is not available in the system.
        if [[ ! -f "/opt/$installer_name" ]]; then

            # Downloading the installer
            curl -L "$url" -o "$installer_name";

        else

            echo "Installer $installer_name is already available in the system."

        fi
    
        # Checking if the package is not installed
        if [[ $(apt policy "$app_name" 2>/dev/null) != *"Installed"* ]]; then

            # Starting the installers code.
            dpkg -i "$installer_name"

        # Checking if the application is already installed.
        else

            # Letting the user know that the application is already available in the system.
            echo "$app_name is already available in the system."

        fi

    done

}

install_softwares_with_flatpak() {
    # A function which installes softwares from flathub using the flatpak package manager.
    # Hint: You can search flatpak packages using the following command: flatpak search --columns=name,description,application appname
    
    # Telling to the user what's happening
    echo "Installing the softwares from flatpak_apps.list file with flatpak package manager"
    
    # Adding the official PPA to your system
    add-apt-repository ppa:flatpak/stable
    
    # Updating the repository information
    apt update
    
    # Adding the flatpak remote repository Hint: A url which tells to flatpak where to look for packages.
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    # Looping through each application in the flatpak_apps.list file.
    for app in $(cat $flathub_list_file_path);do

        # Checking if the application is not installed.
        if [[ $(flatpak list 2>/dev/null) != *"$app"* ]]; then

            # Installing the application.
            flatpak install $app -y;

            # Continuing looping after installation.
            continue

        # Checking if the application is installed.
        else

            # Telling to user that the software is already installed.
            echo "$app is already installed";

        fi

    done

}

install_softwares_with_snap() {
    # A function which installs softwares with snap package manager

    # Telling to the user what's happening
    echo "Installing the softwares from snap_apps.list file with snap package manager"

    # Iterating over each line in the snap_store.list file
    for app in $(cat $snap_store_list_file_path);do

        # Checking if the software which is written in the line is not installed.
        if [[ $(snap list 2>/dev/null) != *"$app"* ]]; then

            # Installing the software which is written in the line.
            snap install $app;

            # Continuing looping after installation.
            continue

        # Checking if the software which is written in the line is installed.
        else

            # Telling to user that the software is already installed.
            echo "$app is already installed";
            
        fi

    done
}

# Calling the main function.
main