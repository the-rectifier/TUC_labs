#define _GNU_SOURCE

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <limits.h>

int create_file(int i, const char * path){
    char wd[PATH_MAX] = {0};
    char ch[4] = {0};
    char junk[256] = "This File is called: ";
    char filename[256] = "FILE_";

    sprintf(ch, "%d", i);
    realpath(path, wd);
    strcat(wd, "/");
    strcat(wd, filename);
    strcat(wd, ch);

    strcat(junk, filename);
    strcat(junk, ch);
    strcat(junk, "\n");

    FILE * fp = fopen(wd, "w");
    fwrite(junk, 1, strlen(junk), fp);
    fclose(fp);

    return 0;
}

void usage(void){
    printf("Usage: \n"
    "./create_files -n [N] -d [directory]\n");
    exit(EXIT_FAILURE);
}

int main(int argc, char * argv[]){

    char ch;
    int no_files;
    const char * directory;

    while ((ch = getopt(argc, argv, "hn:d:")) != -1) {
		switch (ch) {		
		case 'h':
            usage();
            break;
        case 'n':
            no_files = atoi(optarg);
            break;
        case 'd':
            directory = optarg;
            break;
        }
    }    

    for(int i=0;i<no_files;i++){
        create_file(i, directory);
    }

    return 0;
}