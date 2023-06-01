<h1> Project Bash ( Backup && Restore) </h1>

## Overview
The goal of this task is to write 2 bash scripts that perform secure encrypted backup and restore
functionality. You should be able to maneuver through the Linux configuration files and be able
to schedule running the backup script on predefined times. Finally, you will need to copy the
backup to a remote server.

## Backup
RUN Backup 
```
chmod 777 backup.sh
./backup.sh
```
# Featured Backup
1. You should check that the script received 4 parameters from the user and validate the
parameters. You should report errors if any before halting or aborting the script. e.g. user did not
pass enough parameters, provided directories are not valid ones, etc.
2. Your program should print a help message indicating how it should be used if it is invoked
without any parameters.
3. You should store all the parameters passed via the command line into bash variables.
4. You take a snapshot of the full date and store it in a bash variable to be used later. You
should replace any white space or colon with an underscore as we will use this variable to create
directory names and file names; you can use sed to do that :)
5. You need to create a directory whose name should be equivalent to the date taken in point
#4, under the backup directory provided as the second command-line parameter.
6. Your script should loop over all directories under the backup directory provided as the first
user command-line parameter and check for the modification date to backup only modified files
within the number of days specified by the fourth parameter.
7. You should create a tar.gz file using the tar command and the necessary switches under the
created new backup directory. The filename should be <original directory name>_<date>.tgz.
The “date” is the date acquired in point #4.
8. Within the loop, use the gnupg tool to encrypt the file created in point #7, using the
provided key on the command line, in a new file with the same name followed by “.gpg”.
9. Very important: you need to delete the original tar file and keep the encrypted one.

3
10. After you are done with all the directories, you should enumerate all the files located
directly under the backup main directory and group them into one tar.gz file and encrypt it in the
same way.
● It is highly recommended to add the files into the tar archive one by one through using
the tar update switch.
● For the first file you need to use the create switch.
● Then at the end compress the tar file using gzip and delete the tar file.
● Encrypt the tar.gz file using gnupg tool and delete the tar.gz file.
11. After the backup is done, you should copy the backup into a remote server using scp.
## Requirements
- gnupg 
     ```
        sudo apt install gpg
        ```
        
           ```
- SCP Command
```
      sudo scp -i $private $valid_dirStoreTheBackup.tar.gz.gpg $user@$DNS:~/.

```
 
 - Ubuntu/Debian:
  ```
  sudo apt install -y openssh-client openssh-server
  ``` 
## scripts
backup  ====> backup_lib.sh
restore ====> restore_lib.sh

1. backup.sh 
    - functions
      -  validate_backup
      -  backup
2. restore.sh
    - function 
      - validate_restore
      - restore

```
sudo apt install cron
sudo systemctl enable cron

```
## Automate Backup
```
sudo crontab -e
minute hour day_of_month month day_of_week command_to_run
`23 0 0 0 /bin/bash /home/omar/document/backup.sh
`23 0 0 0 /bin/bash /home/omar/document/restore.sh

```

## encryption using GPG

What are GPG keys
GPG stands for GNU Privacy Guard. It uses the concept of Asymmetric encryption. Let’s see how asymmetric encryption works and how is it different from Symmetric encryption which we generally use.

In Symmetric encryption, there is only one key, generally known as password, which we use to encrypt/decrypt the files. Now the problem here is, how will you share the same password over the network to the sender/receiver. This problem is solved in Asymmetric Encryption. Le’s see how.

In Asymmetric encryption, there is a pair of keys, one public and one private. The owner can share the public key with anyone whosoever wants to send the files in an encrypted format. That encrypted file is then sent back to the owner and that can only be decrypted by the corresponding private key.

GPG Use Cases
Encryption: Used to encrypt files. We can some content to someone and you don’t want anyone in the middle to read it.
Signing Commits: Helpful for proving your identity. For eg, you can use this GPG key to sign your commits in Github, to basically verify that you’re the one actually done it.
Encrypting Passwords: Very helpful if you use a command line password utility like a password manager called pass. It uses your GPG keys to handle the encryption for all your secrets you want to store in that password manager.
Install GPG
For Ubuntu/any Debian based distributions

sudo apt install gnupg
## encryption key that you should use to encrypt your backup 

```
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
```



## restore 
## Feature
1. The restore script works the same way as the backup but in the reverse order.
2. Create a temp directory under the restore directory; command-line parameter #2.
3. Loop over all the files in the backup directory; command-line parameter #1.
4. Use gnupg tool to decrypt the files one by one and store the resulting file under the temp
directory created in point #2. Use the decryption key provided via the command-line user input
#3.
5. Loop over the files stored in the temp directory and extract them one by one under the
restore directory; command-line parameter #2.

## parameters
      the first parameter is the directory that contains the backup, 
      the second parameter is the directory that the backup should be restored to, and 
      the third parameter is the decryption key that should be used to restore the backup.
## RUN 
```
chmod 777 restore.sh
./restore.sh
```





  
  

