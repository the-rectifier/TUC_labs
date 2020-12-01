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
LOG="file_logging.log"

rm -rf $LOG
rm -rf $DIR && mkdir $DIR

# Create & encrypt files
for i in $(seq 0 $FILES)
do
    echo "THIS FILE IS CALLED FILE_${i}" > $DIR/FILE_${i}
    LD_PRELOAD=./logger.so openssl enc -aes-256-cbc -in $DIR/FILE_${i} -pbkdf2 -out $DIR/FILE_${i}.encrypt -k $PASS
    rm -rf $DIR/FILE_${i}
done

# test the hashes
for i in $(seq 1 $(($FILES+1)))
do
    # hash from log
    LINE=$((i * 7))
    LOG_HASH="$(echo $(sed "${LINE}q;d" $LOG 2>/dev/null) | rev | cut -d' ' -f 1 | rev)"
    # echo $LOG_HASH
    # hash from file
    FILE_HASH="$(cat $DIR/FILE_$(($i-1)).encrypt | md5sum | sed 's/ -//g' | awk '{print toupper($0) }' )"

    if [[ ${LOG_HASH} != ${FILE_HASH} ]];
    then
        printf "\nFILE_$(($i-1)).encrypt: \n"
        printf "LOG_HASH: ${LOG_HASH}\n"
        printf "CLC_HASH: ${FILE_HASH}\n"  
    fi
done

exit


