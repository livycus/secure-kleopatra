# Secure Kleopatra

*Some key formats may not be supported out of the box but can easily be added in the section following echo Importing keys...*
*The developer of the script does not guarantee that Secure Kleopatra is 100% safe from things such forensic tools employed by malicious entities, use at your own risk.*

## Description

Running script in the same directory as a private key from e.g. hidden VeraCrypt volume, encrypted disk, ... loads keys and Kleopatra into RAM bypassing OS to leave minimal trace on the system.

## Requirements

The script was written and tested only on Debian 12 distribution of linux, it might break on other distros without modification.

## Setup and usage

### Setup

- Create a directory that will keep the keys in persistent memory,
- Place your keys (can be public or private) in directory created in previous step,
- Place secure-kleopatra.sh script in the same directory as you placed your keys,
- Your are now ready to run the script.

### Usage

- Run the script,
- If you followed the setup correctly Kleopatra should now open in a directory created in RAM.
- Once you are finished using Kleopatra navigate to file -> quit and quit out of Kleopatra fully instead of closing it to the task tray,
- When Kleopatra is fully exited the script will clean up the directory created in RAM and prompt you to exit by pressing Enter.
- For maximum security reboot is recommended after usage.

## License

GNU GENERAL PUBLIC LICENSE
Version 3, 29 June 2007

Copyright (C) 2025 livycus
Licensed under the GNU GPL v3. See LICENSE file or https://www.gnu.org/licenses/gpl-3.0.txt or https://opensource.org/license/gpl-3-0.
