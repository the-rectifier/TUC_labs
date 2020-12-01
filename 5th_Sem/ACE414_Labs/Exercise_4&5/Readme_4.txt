Exercise 4 - Access Control: Logger and Monitoring tool
ACE414 - Systems and Services security

Logger - Logs specific fields for each call of fopen and fwrite:
    - User ID
    - Access Type 
    - Access Denied
    - Date: DD-MM-YYYY
    - Time: HH:MM:SS
    - Absolute PATH (also exists for failed opening)
    - MD5 hash of the content:

    Access Denied:
        1 if for any reason fopen returns NULL or fwrite writes 0 bytes.
        0 elsewhere

    Access Types: 
        0 if the file does not exist.
        1 for ANY opening mode regardless if it overwites the content (r, r+, w, w+, a, a+).
            if fopen succeeds (for existing files) then it's treated as opening
        2 only used by fwrite only if one call of fwrite writes 1 or more bytes to the file

    MD5 fingerprint:
        - Hash is created using the contents of the file.
        - Creating a file does NOT count as a modification.
        - Opening an already existing file for writing DOES count as a modification
            since it truncates the file.
        - Failing to open the file will yield 0 for hash, NOT the md5(0).


Monitor - Parses the logfile and creates 2 output types:
    1. Prints all malicious users that tried to access 7 different files without permissions
    2. Given a filename as argument, prints all users who have modified the given file


Tester - Uses the fopen/fwrite functions to create logs. Also writes some log lines that 
DO NOT represent the contents of the files nor the actuall users on the machine, these 
fopen/fwrite calls never took place.

    Testing the logger.so shared library:

    TEST 1
    - First open file_0-file_9 and write to it its name.
    Expected logs:
    2 lines for each file (20 in total). 
        - The first line should have the access type flag 0 for creating and the empty file hash
        - The second line should have the access type flag 2 for writing and the resulting hash

    TEST 2
    - Create 2 junk files, write to them and change their permissions to 000 and tries to open them (twice)
    Expected logs:
    8 lines. 
        - The first 4 are the opening with their respective flags (mentioned above) and the empty, then 
            modified, hashes.
        - The next four lines are after their permissions have changed we should see the access denied flag as true

    TEST 3
    - Open file_4 for reading:
    Expected logs:
    Just one line with the same hash as in TEST 1 since this is just reading.

    TEST 4
    - Open file_2 for appening and append something:
    Expected logs:
    2 lines:
        - The first line has an access type of 1 and the same hash as in TEST one since the contents did not change
        - The second line has an access type of 2 and results in a different hash.

    All tests have finished for the shared library. 

    Testing the monitor:

    Since the logger is wokring as intended i dont need to check what happends for other users, i dont check the getuid() function
    nor the time() function. So i can write logs for calls to fopen/fwrite that never took place to simulate conditions so i can test the monitor functions.

    TEST 1
    Test the malicious users:
    - Write to the logfile 10 times for 10 users, 10 lines for each file, set the access denied flag to 1 to simulate denial. Don't care about the 
        fingerprint right now.
    - Write two more lines with users other than 0-9 and also set the access denied flag.
    Expected output:
    - Since the 10 users accessed more than 7 files the monitor should flag them. By running the monitor with argument -m
        it should print out 10 lines depicting each of the 10 users as malicious.

    TEST 2 
    Test for modifications for a specific file:
    - Write to the logfile 10 times for 10 users, 10 different hashes to simulate modifications.
    Running the monitor with input file argument file_8 should print out 11 lines where file_8 was modified
    1 from user 1000 which was in TEST 1 from the logger tests and 10 more lines for each user and a modifications count of 10


Makefile:
    - make builds the project
    - make run runs the tester with the shared library preloaded
    - make clean cleans all the object files and also removes any files created by the tester 
        also REMOVES the logfile.





