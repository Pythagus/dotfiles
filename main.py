import subprocess
import colorama
import shutil
import sys
import os

# Current script directory absolute path.
CURRENT_DIRECTORY = os.path.dirname(os.path.realpath(__file__))

# Current user home directory absolute path.
HOME_DIRECTORY = os.path.expanduser('~')

# Config files saved in that Git repository.
CONFIG_FILES = [
    '.bashrc',
    '.bash_aliases',
    '.vimrc',
    '.vim/plugins.vim',
    '.config/i3',
    '.config/kitty',
    '.config/compton/config',
    '.config/polybar/color',
    '.config/polybar/config',
    '.config/polybar/launch.sh',
    '.config/rofi/config.rasi',
    '.ssh/config',
]

# Folder created to store the backup files.
BACKUP_FOLDER = '.backup'


# Print a warning message.
def warning(message):
    print(colorama.Fore.YELLOW + "[WARNING] " + message + colorama.Fore.RESET)


# Print an info message.
def info(message):
    print(colorama.Fore.CYAN + "[INFO] " + message + colorama.Fore.RESET)

# Empty the given folder.
def emptyDir(directory):
    for f in os.listdir(directory):
        path = os.path.join(directory, f)

        try:
            shutil.rmtree(path)
        except OSError:
            os.remove(path)


# Create the folders from the path
# that not exists yet.
def createFolderFromPath(path):
    split = path.split("/")

    current_path = '/'
    for item in split[:-1]:
        if len(item) > 0:
            current_path += item + '/'

            # Create directory if not exists.
            if not os.path.isdir(current_path):
                os.mkdir(current_path)


def copyConfigFiles(src_folder, dst_folder, shouldExists=True):
    emptyDir(dst_folder)

    for file_name in CONFIG_FILES:
        sys_path = src_folder + '/' + file_name

        is_file = os.path.isfile(sys_path)
        is_dir = os.path.isdir(sys_path)
        if is_file or is_dir:
            destination = dst_folder + '/' + file_name
            createFolderFromPath(destination)

            if is_file:
                shutil.copy2(sys_path, destination)
            else:
                shutil.copytree(sys_path, destination)
        elif shouldExists:
            warning("File " + file_name + " not found")


# Command manager to execute commands.
class CommandManager(object):
    __slots__ = [
        "commands"
    ]

    # Initialize the CommandManager instance.
    def __init__(self):
        self.commands = []

    # Add a new command.
    def add(self, command):
        self.commands.append(command())

    # Execute the command defined by the given name.
    def execute(self, name, arguments):
        command = self.findName(name)

        if command is None:
            print("ERROR : command " + name + " not found")
            exit(1)

        command.execute(arguments)

    # Find a command from its name.
    def findName(self, name):
        for command in self.commands:
            if command.name == name:
                return command

        return None

    # Check whether a command with the given
    # name was added to the manager.
    def existName(self, name):
        return self.findName(name) is not None


# Abstract class to describe every command.
class Command(object):
    __slots__ = [
        "description", "name"
    ]

    # Abstract method.
    # Execute the command.
    def execute(self, arguments):
        raise NotImplementedError()


# Install the LAMP stack and dependencies.
class CommandInstallLamp(Command):
    # Initialize the save command.
    def __init__(self):
        self.description = "Install the LAMP stack with some dependencies."
        self.name = "install:lamp"

    # Execute the command.
    def execute(self, arguments):
        subprocess.call("./lamp/INSTALL.sh")


# Save the system configs into the Git repository.
class CommandSaveConfig(Command):
    # Initialize the save command.
    def __init__(self):
        self.description = "Save the system configs into the Git repository."
        self.name = "config:save"

    # Execute the command.
    def execute(self, arguments):
        copyConfigFiles(HOME_DIRECTORY, CURRENT_DIRECTORY + '/config')


# Install the configurations from this repository.
class CommandInstallConf(Command):
    # Initialize the save command.
    def __init__(self):
        self.description = "Install the configurations from this repository."
        self.name = "config:install"

    # Execute the command.
    def execute(self, arguments):
        backup = CURRENT_DIRECTORY + '/' + BACKUP_FOLDER

        # Create the backup folder if It not exists.
        if not os.path.isdir(backup):
            os.mkdir(backup)
        else:
            emptyDir(backup)

        info("Saving current configs into " + BACKUP_FOLDER + " folder...")
        copyConfigFiles(HOME_DIRECTORY, backup, shouldExists=False)

        info("Installing the new configs...")
        copyConfigFiles(CURRENT_DIRECTORY + '/config', HOME_DIRECTORY)


manager = CommandManager()
manager.add(CommandSaveConfig)
manager.add(CommandInstallLamp)
manager.add(CommandInstallConf)

# TODO : add ln from python3 to python and py

if __name__ == '__main__':
    args = sys.argv

    if len(args) <= 1:
        print("No arguments")
        # TODO : print help
    else:
        command_name = args[1]
        manager.execute(command_name, args[2::])
