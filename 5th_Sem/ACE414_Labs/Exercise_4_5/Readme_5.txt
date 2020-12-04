Exercise 5 - Access Control: Ransomware and Suspicious activity detection
ACE414 - Systems and Services security

- Ransomware:
    The Ransomware has 3 different modes of operation, depending on the provided arguments:
        1.) File creation in a given directory: ./ransomware -n [N] -d [DIR]
        2.) Encrypt EVERYTHING under given directory: ./ransomware -e [DIR]
        3.) Decrypt EVERYTHING under given directory ./ransomware -u [DIR]
    
    For encryption it uses openssl's AES algorithm with CBC mode and a password of 1234.

    For creating the files the script calls the programm create_files with arguments:
        -n [N] -d [DIR]

    All 3 modes PRELOAD our logger.so to make use of our fopen(64)/fwrite functions

- File Creation:
    The create_files programm creates N files inside the given directory (directory must exist)

- Logger differences:
    1.) Since openssl uses the fopen64 function we need to override the fopen64 function with our own.
        Notes:
            a.) By using that we deny openssl to read files more than 2GB
            b.) We can fix that by adding _FILE_OFFSET_BITS=64 before including any header files or by 
                compiling with the flag : D_FILE_OFFSET_BITS=64. However that makes fopen->fopen64 rendering out 
                logger useless, forcing us to use fopen64 everywhere if we want to acquire logs.
                GNU manual: https://www.gnu.org/software/libc/manual/html_node/Opening-Streams.html
            c.) For this case overriding fopen64 works fine.

    2.) In fwrite we need to initialize the proc_fd and filename buffers to zeroes to avoid writting to bad filenames

    3.) In get_md5, scratch the idea of Seeking to find the file size. Just reopen the file and read 1 byte (512 times) 
        and update the hash as needed.

- Monitors additions:
    - Listing encrypted files:
        Read the log file line by line. For each filename read check if it ends with the extention ".encrypt" and also 
        if the acces_type is 0 (created). Means that the file without the extention was encrypted. Print that file
        (without the extention) and increment the count variable. At the end print how many files were encrypted.
    
    - List files created in the last 20 mins:
        Log the current time. Read the log file line by line. If the action was granted and the acces_type indicates creation, 
        then recreate the broken down time structure and then create the time in seconds since Epoch. Find their difference in
        mins. If the difference falls in the 20 mins range then increment the count variable. At the end if the created files 
        are more than the threshold provided print a message of Suspicious activity.

    


