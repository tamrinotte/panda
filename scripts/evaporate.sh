#!/bin/bash
set -e

main() {

    declare_variables

    remove_unwanted_softwares

    apt-get clean

    apt-get autoclean

}

declare_variables() {

    unnecessary_apps_list_file_path="/opt/panda/configuration_files/unnecessary_apps.list"

}

remove_unwanted_softwares() {

    for app in $(cat $unnecessary_apps_list_file_path);do

        if [[ $(apt policy "$app" 2>/dev/null) != *"Installed: (none)"* ]]; then

            if [[ $(apt policy "$app" 2>/dev/null) == *"Installed: (none)"* ]]; then

                echo "$app is not installed, so not purging."

            else

                echo "Deleting $app"

                apt purge --auto-remove "$app" -y

                echo "$app has been deleted"

            fi

        else

            echo "$app is not found in the repository."

        fi

    done

}

main
