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
    '.config/i3/config',
    '.config/kitty/kitty.conf',
    '.config/kitty/theme.conf',
    '.config/compton/config',
    '.config/polybar/color',
    '.config/polybar/config',
    '.config/polybar/launch.sh',
    '.config/rofi/config.rasi',
    '.ssh/config',
]

# Folder created to store the backup files.
BACKUP_FOLDER = '.backup'


# Base print with colors.
def print_color(color, message):
    print(color + message + colorama.Fore.RESET)


# Print an error message
def error(message, code=1):
    print_color(colorama.Fore.RED, "[ERROR] " + message)
    exit(code)


# Print a warning message.
def warning(message):
    print_color(colorama.Fore.YELLOW, "[WARNING] " + message)


# Print an info message.
def info(message):
    print_color(colorama.Fore.CYAN, "[INFO] " + message)


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


# Copy the configuration files from the
# source to the destination.
def copyConfigFiles(src_folder, dst_folder, shouldExists=True):
    for file_name in CONFIG_FILES:
        sys_path = src_folder + '/' + file_name

        if os.path.isdir(sys_path):
            error("Config file must not be a folder")

        if os.path.isfile(sys_path):
            destination = dst_folder + '/' + file_name
            createFolderFromPath(destination)
            shutil.copy2(sys_path, destination)
        elif shouldExists:
            warning("File " + file_name + " not found")


# Check whether the user is root,
# and display an error if not.
def mustBeRoot():
    if os.geteuid() != 0:
        error("You need to be root to execute this command")


# Install the VS code configs.
def installVisualStudioConf():
    vs_ext_file = CURRENT_DIRECTORY + '/visual-studio/extensions.txt'
    if os.path.isfile(vs_ext_file) :
        info("Installing Visual Studio Code extensions...")
        with open(vs_ext_file, 'r') as ext_file:
            for line in ext_file:
                extension = line.rstrip("\n")

                if len(extension) > 0:
                    subprocess.call('code --install-extension ' + extension + " > /dev/null", shell=True)


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
        instance = command()
        instance.setManager(self)
        self.commands.append(instance)

    # Execute the command defined by the given name.
    def execute(self, name, arguments):
        command = self.findName(name)

        if command is None:
            error("Command " + name + " not found")

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
        "description", "name", "manager"
    ]

    # Set the manager instance.
    def setManager(self, manager):
        self.manager = manager

    # Abstract method.
    # Execute the command.
    def execute(self, arguments):
        raise NotImplementedError()


# Install Visual Studio command.
class CommandInstallVisualStudio(Command):
    # Initialize Visual Studio command.
    def __init__(self):
        self.description = "Install Visual Studio"
        self.name = "install:vscode"

    # Execute the command.
    def execute(self, arguments):
        info("Installing Visual Studio Code...")
        subprocess.call(["sudo", './visual-studio/INSTALL.sh'])
        installVisualStudioConf()


# Install the LAMP stack and dependencies.
class CommandInstallLamp(Command):
    # Initialize the save command.
    def __init__(self):
        self.description = "Install the LAMP stack with some dependencies."
        self.name = "install:lamp"

    # Execute the command.
    def execute(self, arguments):
        subprocess.call(["sudo", "./lamp/INSTALL.sh"])


# Save the system configs into the Git repository.
class CommandSaveConfig(Command):
    # Initialize the save command.
    def __init__(self):
        self.description = "Save the system configs into the Git repository."
        self.name = "config:save"

    # Execute the command.
    def execute(self, arguments):
        config_folder = CURRENT_DIRECTORY + '/config'

        # Save general configs.
        emptyDir(config_folder)
        copyConfigFiles(HOME_DIRECTORY, config_folder)

        # Save VisualStudioCode configs.
        subprocess.call('code --list-extensions > ' + CURRENT_DIRECTORY + '/visual-studio/extensions.txt', shell=True)


# Install the configurations from this repository.
class CommandInstallConf(Command):
    # Initialize the install command.
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

        installVisualStudioConf()


# Create a virtual Apache2 host.
class CommandApacheCreateHost(Command):
    # Initialize the creating host command/
    def __init__(self):
        self.description = "Create an apache2 virtual host"
        self.name = "apache:host"

    # Execute the command.
    def execute(self, arguments):
        mustBeRoot()

        if len(arguments) != 2:
            error(self.name + " wants 2 arguments, " + str(len(arguments)) + " given")

        # Check name.
        name = str(arguments[0]).lower()
        if any(not c.isalpha() for c in name):
            error("Apache2 host should only contain letters (" + name + " given)")

        # Check code location.
        code_location = str(arguments[1])
        if code_location[0] == '/':
            code_location = code_location[1:]

        # Copy the default config file.
        path = './lamp/'
        conf_name = name + '.conf'
        conf_path = path + conf_name
        shutil.copy2(path + '000-default.conf', conf_path)

        # Replace items in file.
        with open(conf_path, 'r') as f:
            conf_text = f.read()
            conf_text = conf_text.replace('SERVER_NAME', name + '.host')
            conf_text = conf_text.replace('CODE_LOCATION', code_location)

        # Put the changed content into the file.
        with open(conf_path, "w") as f:
            f.write(conf_text)
        
        # Append the host at the beginning of
        # the /etc/hosts file.
        with open('/etc/hosts', 'r+') as f:
            content = f.read()
            f.seek(0, 0)
            f.write("127.0.0.1       " + name + '.host\n' + content)

        shutil.move(conf_path, '/etc/apache2/sites-available/' + conf_name)
        subprocess.call(['a2ensite', conf_name])
        subprocess.call(['systemctl', 'reload', 'apache2'])


manager = CommandManager()
manager.add(CommandSaveConfig)
manager.add(CommandInstallLamp)
manager.add(CommandInstallVisualStudio)
manager.add(CommandInstallConf)
manager.add(CommandApacheCreateHost)

# TODO : add ln from python3 to python and py

if __name__ == '__main__':
    args = sys.argv

    if len(args) <= 1:
        print("No arguments")
        # TODO : print help
    else:
        command_name = args[1]
        manager.execute(command_name, args[2::])
