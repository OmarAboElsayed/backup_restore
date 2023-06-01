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
. ./restore_lib.sh
clear
echo -e "${blue}
              *         *      *         *
          ***          **********          ***
       *****           **********           *****
     *******           **********           *******
   **********         ************         **********
  ****************************************************
 ******************************************************
****************${white}Welcome to resrore script ${blue}*************
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
echo -e "${blue}the first parameter is the directory that contains the backup, 
      the second parameter is the directory that the backup should be restored to, and 
      the third parameter is the decryption key that should be used to restore the backup."
echo -e "${white}"

restore
