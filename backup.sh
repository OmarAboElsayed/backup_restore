#!/usr/bin/bash

# Color variables
export red='\033[1;91m'
export green='\033[0;32m'
export yellow='\033[0;33m'
export blue='\033[0;34m'
export magenta='\033[0;35m'
export Purple='\033[0;35m'
export white='\033[1;37m'
export Cyan='\033[0;36m' 
export IsNumber='^[0-9]+$'


. ./backup_lib.sh
clear
echo -e "${blue}
              *         *      *         *
          ***          **********          ***
       *****           **********           *****
     *******           **********           *******
   **********         ************         **********
  ****************************************************
 ******************************************************
****************${white}Welcome to Backup script ${blue}*************
********************************************************
********************************************************
 ******************************************************
  ********      ************************      ********
   *******       *     *********      *       *******
     ******             *******              ******
       *****             *****              *****
          ***             ***              ***
            **             *              **
             *                            *
            "

## Help instructions ##
# help message indicating how it should be used if it is invoked without any parameters.

echo -e "${blue}the first parameter is the directory to be backed up, 
        the second parameter is the directory which should store eventually the backup, and 
        the third parameter is an encryption key that you should use to encrypt your backup and 
        the fourth parameter is number of days (n) that the script should use to backup only the changed files during the last n days."
         echo -e "${white}"

# call function 
backup

