#! /bin/bash
PS3="Please Enter your Options: "
# first function : backup funtction 
function backup {

# the full date and store it in a bash variable and replace any white space or colon with an underscore 
DateFormate=$(date | sed "s/:/_/g" | sed "s/ /_/g")

# create a directory whose name should be equivalent to the date taken in point
mkdir $HOME/$DateFormate

# list all directory in Home directory
ls $HOME
validate_backup
main_directories=$(ls "$HOME"/$valid_dirToBeBackup)
for dir in $main_directories; do
  if [ -d "$HOME"/$valid_dirToBeBackup/$dir ]
then
  mkdir -p "$HOME"/$valid_dirStoreTheBackup/$dir
  find "$HOME"/$valid_dirToBeBackup/$dir -type f -mtime "$valid_n" -exec cp {} "$HOME"/$valid_dirStoreTheBackup/$dir \;
  find "$HOME"/$valid_dirStoreTheBackup/ -type d -empty  -delete
  fi
done
cd "$HOME"/$valid_dirStoreTheBackup
archive_directories=$(ls "$HOME"/$valid_dirStoreTheBackup)
for tar in $archive_directories; do
  tar czvf $tar-$DateFormate.tar.gz  $tar/*
  gpg --encrypt $tar-$DateFormate.tar.gz
  rm -Rf $tar
  rm $tar-$DateFormate.tar.gz
done
cd "$HOME"
tar czvf $valid_dirStoreTheBackup.tar.gz  $valid_dirStoreTheBackup
gpg --encrypt $valid_dirStoreTheBackup.tar.gz
rm -Rf $valid_dirStoreTheBackup
rm $valid_dirStoreTheBackup.tar.gz
echo "After the backup is done, you should copy the backup into a remote server using scp."
echo "now do you want to upload your encrypt directory to remote server (ec2) you should prepare ec2 first (Y/N)"
read anse
case $anse in
      "Y" | "y" | "YES" | "Yes" | "yes" )
      echo "Enter path of private keyPair for ec2 "
      read private
      echo "Enter Public IPv4 DNS for ec2"
      read DNS
      echo "Enter user name for  ec2"
      read $user

      sudo scp -i $private $valid_dirStoreTheBackup.tar.gz.gpg $user@$DNS:~/.


      ;;
     "N" | "n" | "No" | "NO" | "no" | "nO" )

      ;;
   *)
    esac

}

# second  function : validate backup  
function validate_backup {

# the first parameter is the directory to be backed up,
echo -e "the first parameter is the directory to be backed up" 
read $dirToBeBackup

# check if directory is exist or not 
if [  -d $HOME/$dirToBeBackup ]
then
valid_dirToBeBackup= $dirToBeBackup
echo -e " ${green}directory name is valid!"
echo -e "${white}"
else
  echo -e "${red}directory name is not valid!"
  echo -e "${white}"

 	select choice in "choose another dir" "exit"
 	do
	case $REPLY in

	1) echo -e "Enter directory  exit : $dirToBeBackup" 
	  if [  -d "$HOME"/"$dirToBeBackup" ]
	  then
    valid_dirToBeBackup="$dirToBeBackup"
    echo  -e "${green}directory name is valid!"
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
		
		echo -e  "$red $REPLY is not the correct choice!"
    echo -e "${white}"

			;;
		esac
		done

    fi

# the second parameter is the directory which should store eventually the backup,
echo -e "the second parameter is the directory which should store eventually the backup"
read dirStoreTheBackup

# check if directory is exist or not 
if [  -d $HOME/$dirStoreTheBackup ] && [[ $dirStoreTheBackup != $dirToBeBackup ]];
then
valid_dirStoreTheBackup=$dirStoreTheBackup
echo -e "${green}directory name is valid!"
echo -e "${white}"

else
  echo -e "$red directory name is not valid! "
  echo -e "${white}"

 	select choice in "choose another dir" "exit"
 	do
	case $REPLY in
	1)echo -e "Enter another directory: $dirStoreTheBackup"
	  
	  if [  -d "$HOME"/"$dirStoreTheBackup" ]
	  then
    valid_dirStoreTheBackup="$dirStoreTheBackup"
    echo -e "${green}directory name is valid!"
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

# the third parameter is an encryption key that you should use to encrypt your backup
echo -e  "the third parameter is an encryption key that you should use to encrypt your backup
 directory \n Pres yes if you want to generate key or NO to something else ? (Y/N)"
 read answer

case $answer in
      "Y" | "y" | "YES" | "Yes" | "yes" )
    # Set the filename of the file to be encrypted and the name and email address for the new keypair
filename="file.txt"
name="omar mohamed"
email="omaraboelsayed2000@gmail.com"

# Generate a new GPG keypair
# Set the filename of the file to be encrypted and the name and email address for the new keypair
filename="file.txt"
name="omar mohamed"
email="omaraboelsayed2000@example.com"
passphrase="mysecretpassphrase"

# Generate a new GPG keypair with default settings
echo -e "Key-Type: RSA\nKey-Length: 2048\nSubkey-Type: RSA\nSubkey-Length: 2048\nName-Real: $name\nName-Email: $email\nExpire-Date: 0\nPassphrase: $passphrase\n%commit\n" | gpg --batch --generate-key

# Export the public key and save it to a file
gpg --armor --output public_key.asc --export "$email"

# Sign the public key with your existing key
gpg --armor --output signed_public_key.asc --sign-key "$email"

# Encrypt the file using the new public key
gpg --symmetric --cipher-algo AES256 --batch --yes --passphrase "$passphrase" --output "$filename.gpg" "$filename"
gpg --encrypt --recipient "$email" "$filename"

echo -e"${green}Encryption complete!"
echo -e "${white}"
     

      ;;
     "N" | "n" | "No" | "NO" | "no" | "nO" )
       
      ;;
   *)
    esac

echo "the fourth parameter is number of days (n) that the script should use to backup only the changed files during the last n days."
read n
if [[ $n =~ ^[0-9]+$ ]]
then
  valid_n=$n
else
  echo -e "${red} is not valid!"
  echo -e "${white}"
  
  select choice in "Enter number days again" "exit"
  do
	case $REPLY in
	1) echo "Enter number days again"
	    read n
      if [[ $n =~ ^[0-9]+$ ]]
        then
          valid_n=$n
          break
       else
        echo -e "${red} $n is not valid!"
        echo -e "${white}"

      fi
  ;;
  2) exit
  ;;
		*)
	
		echo -e "${red} $REPLY is not the correct choice!"
    echo -e "${white}"

			;;
		esac
		done
		fi
}

