#!/bin/bash

main() {

    # Calling the declare_variables function.
    declare_variables

    # Calling the stop_and_disable_unnecessary_services function.
    stop_and_disable_unnecessary_services

}

declare_variables() {
    # A function which declares variables.

    # Creating a path which references to the list of dangerous services
    dangerous_services_file_path="/opt/panda/configuration_files/dangerous_services.list"

}

stop_and_disable_unnecessary_services() {

    for service in $(cat $dangerous_services_file_path);do

        if [[ $(systemctl is-active "$service") == "active" ]]; then

            echo "Stopping $service"

            systemctl stop "$service"

        fi

        if [[ $(systemctl is-enabled "$service") == "enabled" ]]; then

            echo "Disabling $service"

            systemctl disable "$service"

        fi

    done
    
}

# Calling the main function.
main
