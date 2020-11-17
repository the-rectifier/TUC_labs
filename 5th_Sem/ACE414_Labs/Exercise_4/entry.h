//
// Created by canopus on 11/17/20.
//

#ifndef EXERCISE_4_ENTRY_H
#define EXERCISE_4_ENTRY_H

#endif //EXERCISE_4_ENTRY_H

#include <time.h>

#define NULL_MD5 "CFCD208495D565EF66E7DFF9F98764DA"
#define EMPTY_MD5 "D41D8CD98F00B204E9800998ECF8427E"
#define LOG_FILE "file_logging.log"

struct entry{
    int uid; /* user id (positive integer) */
    int access_type; /* access type values [0-2] */
    int action_denied; /* is action denied values [0-1] */

    struct tm time;

    const char *file; /* filename (string) */
    char fingerprint[MD5_DIGEST_LENGTH*2 +1]; /* file fingerprint */
};

void get_md5(FILE *, char *);

void write_log(struct entry);

void print_hex(unsigned char *, size_t);