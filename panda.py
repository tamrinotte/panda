# This Python file uses the following encoding: utf-8

# ASCII arts are from https://texteditor.com/ascii-art/

# MODULES AND/OR LIBRARIES
from pathlib import Path
from logging import basicConfig, DEBUG, debug, disable, CRITICAL
from sys import exit as sysexit, argv
from os import listdir, system

# Configuring debugging feature code
basicConfig(level=DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')

# Disabling the debugging feature. Hint: Comment out this line to enable debugging.
# disable(CRITICAL)

# GLOBAL VARIABLES

base_dir_path = Path("/opt/panda")

scripts_dir_path = Path(base_dir_path, "scripts")

app_lists_dir_path = Path(base_dir_path, "app_lists")

configuration_files_dir_path = Path(base_dir_path, "configuration_files")


# ANSI color codes for styling text
purple_color = "\033[95m"

golden_color = "\033[38;5;214m"

light_blue_color = "\033[36m"

reset_color = "\033[0m"


# Template for formatting command and description
template = "{:<10}{}"


scripts_dict = {

    'Evaporate': Path(scripts_dir_path, 'evaporate.sh'),

    'Steamline': Path(scripts_dir_path, 'streamline.sh'),

    'Fortify': Path(scripts_dir_path, 'fortify.sh'),

    'Cloack': Path(scripts_dir_path, 'cloack.sh'),

    'Eye of Oracle': Path(scripts_dir_path, 'eye_of_oracle.sh'),

    'Repo Update': Path(scripts_dir_path, 'repo_update.sh'),

    'Seal': Path(scripts_dir_path, 'seal.sh'),

    'Sunwell': Path(scripts_dir_path, 'sunwell.sh'),

    'Upgrade': Path(scripts_dir_path, 'upgrade.sh'),

    'Finale': Path(scripts_dir_path, 'finale.sh'),
 
}

command_dict = {

    'edit': 'Opens the edit screen where the user can select what he/she wants to edit.',

    'start': 'Starts the application',

}

editable_options = {

    'App Lists': 'Edit the app list files which contains the list of apps that will be downloaded from different sources.',

    'Unnecessary Apps List': 'Edit the list of apps that are unnecessary and will be deleted by panda if they are available in the system.',

    'Service List': "Edit the list of services that you want it to be stopped and disabled.",

    'Firewall': 'Edit the firewall rules',

}

# List of arguments for displaying the help page
help_page_arguments = ['-h', '--help']

def show_the_help_page():
    """A function which shows the help page"""

    print(f'{golden_color}𝓗𝓮𝓵𝓹{reset_color}')

    help_text = """
Usage: panda [command/option]

Description:
    Panda setup is a setup assistant which sets up a machine for users.

Commands:
{}

Options:
  -h, --help      Shows this help message and exits.
""".format("\n".join(template.format(k, v) for k, v in command_dict.items()))

    print(help_text)

def edit_mode():
    """A function which opens the edit mode"""

    print(f'{golden_color}𝓔𝓭𝓲𝓽{reset_color}\n')

    while True:

        try:

            for index, option in enumerate(editable_options.keys()):

                print(f'{index}) {option}')

            print()

            user_choice = str(input("Enter your choice: ")).strip().lower()

            print()

            if user_choice == "0":

                print("App Lists\n")

                for index, file_name in enumerate(listdir(app_lists_dir_path)):

                    print(f'{index}) {file_name}')

                print()

                file_choice = int(input("Enter your choice here: "))

                print()

                selected_file_path = Path(app_lists_dir_path, listdir(app_lists_dir_path)[file_choice])

                system(f'nano {selected_file_path}')

            elif user_choice == "1":

                unnecessary_apps_list_file_path = Path(configuration_files_dir_path, 'unnecessary_apps.list')

                system(f'nano {unnecessary_apps_list_file_path}')

            elif user_choice == "2":

                service_list_file_path = Path(configuration_files_dir_path, 'services.list')

                system(f'nano {service_list_file_path}')

            elif user_choice == "3":
                
                firewall_script_file_path = Path(scripts_dir_path, "fortify.sh")

                system(f'nano {firewall_script_file_path}')

            else:
                
                print("Exiting...")
                
                break

        except:

            print("Exiting...")

            break

def start_the_app():
    """A function which starts the application"""

    print(f'{golden_color}𝓢𝓽𝓪𝓻𝓽{reset_color}')

    for title, file_path in scripts_dict.items():

        print(f'\n{light_blue_color}{title}{reset_color}\n')

        if title != 'Eye of Oracle':

            system(f'sudo bash "{scripts_dict[title]}"')

        else:

            system(f'bash "{scripts_dict[title]}"')

def main():
    """The function which runs the entire program"""
    
    banner = """{}
  _____                _       
 |  __ \              | |      
 | |__) |_ _ _ __   __| | __ _ 
 |  ___/ _` | '_ \ / _` |/ _` |
 | |  | (_| | | | | (_| | (_| |
 |_|   \__,_|_| |_|\__,_|\__,_|{}                  
""".format(purple_color, reset_color)

    print(banner)

    if len(argv) == 2:

        user_command = argv[1]
        
        if user_command == list(command_dict.keys())[0]:

            edit_mode()

        elif user_command == list(command_dict.keys())[1]:

            start_the_app()

        elif user_command in help_page_arguments:

            show_the_help_page()

        else:

            print(f'Invalid command. Please refer to the help page to get more information about the usage. "panda {help_page_arguments[0]}"')

    else:

        print(f'Invalid usage. Please refer to the help page to get more information about the usage. "panda {help_page_arguments[0]}"')

# Evaluate if the source is being run on its own or being imported somewhere else. With this conditional in place, your code can not be imported somewhere else.
if __name__ == "__main__":

    # Calling the main function
    main()
