#define _GNU_SOURCE

#include <time.h>
#include <stdio.h>
#include <dlfcn.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/stat.h>
#include <openssl/md5.h>

#include "entry.h"

FILE * fopen(const char *path, const char *mode){
    struct entry entry;
    int existed = 1;

    time_t t = time(NULL);
    entry.time = *localtime(&t);
    entry.action_denied = 0;
    entry.uid = getuid();
    memset(entry.fingerprint, 0, MD5_DIGEST_LENGTH*2+1);

    if(access( path, F_OK ) == -1){
        existed = 0;
    }

	FILE *original_fopen_ret;
	FILE *(*original_fopen)(const char*, const char*);

	/* call the original fopen function */
	original_fopen = dlsym(RTLD_NEXT, "fopen");
	original_fopen_ret = (*original_fopen)(path, mode);

	// check if !NULL ptr returned for a non existant file
	// if not null then file was created => access type = 0
	// if existed was true then we opened succesfully access type = 1
	// else we were denied access access denied = 1
	if(original_fopen_ret != NULL && !existed){
        entry.access_type = 0;
        memcpy(entry.fingerprint, EMPTY_MD5, MD5_DIGEST_LENGTH*2 +1);
        entry.file = realpath(path, NULL);
	}else if(original_fopen_ret != NULL){
        entry.access_type = 1;
        get_md5(original_fopen_ret, entry.fingerprint);
        entry.file = realpath(path, NULL);
	}else{
	    entry.file = path;
	    entry.action_denied = 1;
        memcpy(entry.fingerprint, NULL_MD5, MD5_DIGEST_LENGTH*2 +1);
	}

	write_log(entry);

	if(entry.file != NULL && original_fopen_ret != NULL)
	    free((void *)entry.file);
	return original_fopen_ret;
}


size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream){
    /**
     * Create new entry struct and init the values we already know
     * We are writing so by default the access type is 2
     * uid is the current user
     * time is the current time
     */
    struct entry entry;
    entry.access_type = 2;
    entry.uid = getuid();
    time_t t = time(NULL);
    entry.time = *localtime(&t);
    memset(entry.fingerprint, 0, MD5_DIGEST_LENGTH*2+1);

    /**
     * Get the current file descriptor and sequentialy the filename
     * grab the absolute path from the filename
     */
    int fd = fileno(stream);
    char proc_fd[255];
    char filename[255];
    sprintf(proc_fd, "/proc/self/fd/%d", fd);
    readlink(proc_fd, filename, 255);
    entry.file = realpath(filename, NULL);

	size_t original_fwrite_ret;
	size_t (*original_fwrite)(const void*, size_t, size_t, FILE*);

	/* call the original fwrite function */
	original_fwrite = dlsym(RTLD_NEXT, "fwrite");
	original_fwrite_ret = (*original_fwrite)(ptr, size, nmemb, stream);

    if(!original_fwrite_ret){
        entry.action_denied = 1;
    }else{
        entry.action_denied = 0;
    }

    get_md5(stream, entry.fingerprint);
    write_log(entry);
    free((void *)entry.file);
	return original_fwrite_ret;
}

FILE * fopen_orig(const char *path, const char *mode){

    FILE *original_fopen_ret;
    FILE *(*original_fopen)(const char*, const char*);

    /* call the original fopen function */
    original_fopen = dlsym(RTLD_NEXT, "fopen");
    original_fopen_ret = (*original_fopen)(path, mode);

    return original_fopen_ret;
}

void write_log(struct entry entry){
    FILE * fp = fopen_orig(LOG_FILE, "a");

    fprintf(fp,
            "%d\t%s\t%d\t%d\t%02d-%02d-%d\t%02d:%02d:%02d\t%s\n",
            entry.uid,
            entry.file,
            entry.action_denied,
            entry.access_type,
            entry.time.tm_mday,
            entry.time.tm_mon + 1,
            entry.time.tm_year + 1900,
            entry.time.tm_hour,
            entry.time.tm_min,
            entry.time.tm_sec,
            entry.fingerprint);

    fclose(fp);
}

void get_md5(FILE * fp, char buffer[]){
    int filesize;
    unsigned char hash[MD5_DIGEST_LENGTH];
    unsigned char * temp;

    fseek(fp,0, SEEK_END);
    filesize = ftell(fp);
    rewind(fp);

    temp = (unsigned char *)malloc(filesize);
    fread(temp, filesize, 1, fp);

    MD5_CTX ctx;

    MD5_Init(&ctx);

    MD5_Update(&ctx, temp, filesize);

    MD5_Final(hash, &ctx);

    print_hex(hash, MD5_DIGEST_LENGTH);

    for(int i=0,j=0;i<MD5_DIGEST_LENGTH;i++,j+=2){
        sprintf(&buffer[j], "%02X", hash[i]);
    }

    free(temp);
}

void print_hex(unsigned char *data, size_t len){
    size_t i;

    if (!data)
        printf("NULL data\n");
    else{
        for (i = 0; i < len; i++) {
            printf("%02X", data[i]);
        }
        printf("\n");
    }
}