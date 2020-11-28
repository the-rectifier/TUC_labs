#!/usr/bin/bash



if [ "$EUID" -eq 0 ] 
then 
    echo "Do NOT run as root!"
    exit
fi


# function usage(){
#     printf "Usage: ./ransomware -x number_of_files -d directory\n"
#     printf "Options: \n"
#     printf "-x|--files  Amount of files to be created\n"
#     printf "-d|--dir    Directory to place them\n"
#     printf "-h|--help   This help message\n"
#     printf "Note: The given directory is DELETED, be careful\n"
#     printf "Note: Created files are then deleted\n"

#     return 0
# }

if [[ $# -ne 2 ]];
    then
    echo "Usage: ./ransomware #of_files directory"
    exit 
fi

FILES=$1
DIR=$2
PASS="1234"

rm -rf $DIR && mkdir $DIR

# Create & encrypt files
for i in $(seq 0 $FILES)
do
    echo "THIS FILE IS CALLED FILE_${i}" > $DIR/FILE_${i}
    LD_PRELOAD=./logger.so openssl enc -aes-256-ecb -in $DIR/FILE_${i} -out $DIR/FILE_${i}.encrypt -k $PASS
    rm -rf $DIR/FILE_${i}
done

exit


