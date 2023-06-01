function restore {
validate_restore
mkdir $HOME/$restored_directory
echo "restore directory created and is ready at $HOME/$"
echo "list all archive_directories to help you to select your directory"
ls $HOME 
decrypt_backup_directory=$(sed 's/.\{4\}$//' <<<$encrypt_backup_directory)
gpg --decrypt --output "$HOME"/$decrypt_backup_directory $HOME/$encrypt_backup_directory 
mv $HOME/$decrypt_backup_directory $HOME/$restored_directory
cd $HOME/$$restored_directory
tar xzf $decrypt_backup_directory
rm $decrypt_backup_directory
cd "$HOME"/$dirStoreTheBackup
restore_directories=$(sed 's/.\{7\}$//' <<<$decrypt_backup_directory)
restore_subdirectories=$(ls $HOME/$restored_directory/$restore_directories)
echo $restore_subdirectories
cd "$HOME"/$restored_directory/$restore_directories
ls
for decrypt in $restore_subdirectories; do
  decrypt_backup_subdirectory=$(sed 's/.\{4\}$//' <<<$decrypt)
  gpg --decrypt --output "$HOME"/$restored_directory/$restore_directories/$decrypt_backup_subdirectory "$HOME"/$restored_directory/$restore_directories/$decrypt
  tar xzf $decrypt_backup_subdirectory
  rm $decrypt_backup_subdirectory
  rm $decrypt
done
}

function validate_restore {
  echo "Enter restored directory "
  read restored_directory
	  if [ ! -d "$HOME"/$restored_directory ]
      then
        restored_directory=$restored_directory
        echo "directory name is valid!"
    else
      echo "directory name is not valid! there is another directory has same name "
 	select choice in "choose another name" "exit"
 	do
	case $REPLY in
	1)echo "Enter another directory"
	  read restored_directory

	  if [ ! -d "$HOME"/$restored_directory ]
	  then
    restored_directory="$restored_directory"
    echo -e  "${green}directory  is valid!"
    echo -e "${white}"
    break
    else
      echo -e "${red}directory name is not valid!"
       echo -e "${white}"
    fi
  ;;
  2) 
    exit
  ;;
		*)
		
		echo -e "${red} $REPLY is not the correct choice!"
     echo -e "${white}"
			;;
		esac
		done
      fi


echo "Enter your encrypt backup directory path "
read encrypt_backup_directory
if [  -e $HOME/$encrypt_backup_directory ]
then
encrypt_backup_directory=$encrypt_backup_directory
echo -e "${green}found the directory "
 echo -e "${white}"
else
  echo -e "${red}unfounded the directory"
   echo -e "${white}"
 	select choice in "choose another name" "exit"
 	do
	case $REPLY in
	1)echo "Enter another directory"
	  read encrypt_backup_directory
	  if [  -e "$HOME"/"$encrypt_backup_directory" ]
	  then
    encrypt_backup_directory="$encrypt_backup_directory"
echo -e "${green}found the directory "
 echo -e "${white}"
    break
    else
  echo -e  "${red} unfounded directory"
   echo -e "${white}"
    fi
  ;;
  2) 
    exit
  ;;
		*)
		
		echo "${red} $REPLY is not the correct choice!"
     echo -e "${white}"
			;;
		esac
		done
		fi

		echo -e  "3) encryption key that you should use to decrypt your backup directory \n  do you have encryption key ? (Y/N) "
read answer
case $answer in
      "Y" | "y" | "YES" | "Yes" | "yes" )
      echo " continue decryption"
      ;;
     "N" | "n" | "No" | "NO" | "no" | "nO" )
        echo " to import the key from someone a GPG key find it in documentation "
 
      ;;
   *)
    esac
}
