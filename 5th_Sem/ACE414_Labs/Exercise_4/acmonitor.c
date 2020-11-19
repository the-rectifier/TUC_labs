#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>

#include "entry.h"


void usage(void) {
	printf(
	       "\n"
	       "Usage:\n"
	       "\t./monitor \n"
		   "Options:\n"
		   "-m, Prints malicious users\n"
		   "-i <filename>, Prints table of users that modified "
		   "the file <filename> and the number of modifications\n"
		   "-h, Help message\n\n"
		   );

	exit(1);
}


void list_unauthorized_accesses(FILE *log){
	struct user * failures = NULL;
	struct user * temp = NULL;

	int uid;
	int action_denied;
	int access_type;

	char filename[PATH_MAX] = {0};

	int lines = 0;
	char ch;
	
	while(!feof(log)){
		ch = fgetc(log);
		if(ch == '\n')
			lines++;
	}
	rewind(log);

	for(int i=0;i<lines;i++){
		fscanf(log,
            "%d\t%s\t%d\t%d\t%*02d-%*02d-%*d\t%*02d:%*02d:%*02d\t%*s\n",
            &uid,
            filename,
            &action_denied,
			&access_type);

		printf("UID: %d\tFILENAME: %s\tACTION_DENIED: %d\tACCES_TYPE: %d\n",
		uid,filename, action_denied, access_type);
		/* first time encountering a failure */
		if(failures == NULL && action_denied){
			temp = (struct user *)malloc(sizeof(struct user));
			temp->access_fail = 1;
			temp->uid = uid;
			temp->access_type = access_type;

			memcpy(temp->filenames[0], filename, PATH_MAX);
			temp->next = NULL;
			failures = temp;
		}else if(action_denied){
			if((temp = in_list(failures, uid)) == NULL){
				new_user(failures, uid, filename, access_type);
			}else{
				add_failure(temp, filename);
			}
		}
	}
	temp = failures;
	while(temp != NULL){
		if(temp->flagged){
			printf("Malicous User (UID): %d\n", temp->uid);
		}
		temp = temp->next;
	}
	while(failures != NULL){
		temp = failures->next;
		free(failures);
		failures = temp;
	}
	return;
}


void list_file_modifications(FILE *log, char *file_to_scan){

	return;

}


int main(int argc, char *argv[]){

	int ch;
	FILE *log;

	if (argc < 2)
		usage();

	log = fopen("./file_logging.log", "r");
	if (log == NULL) {
		printf("Error opening log file \"%s\"\n", "./log");
		return 1;
	}

	while ((ch = getopt(argc, argv, "hi:m")) != -1) {
		switch (ch) {		
		case 'i':
			list_file_modifications(log, optarg);
			break;
		case 'm':
			list_unauthorized_accesses(log);
			break;
		default:
			usage();
		}

	}

	fclose(log);
	argc -= optind;
	argv += optind;	
	
	return 0;
}


struct user * in_list(struct user * user, int key){
    while(user->next != NULL){
        if(user->uid == key){
            return user;
        }
        user = user->next;
    }
    return NULL;
}

/* adds new failure to failures */
void new_user(struct user * list, int uid, char * filename, int access_type){
	struct user * new = (struct user *)malloc(sizeof(struct user));
	struct user * tmp = list;

	while(tmp->next != NULL){
		tmp = tmp->next;
	}

	tmp->next = new;
	new->uid = uid;
	new->access_type = access_type;
	new->access_fail = 1;
	new->next = NULL;

	memcpy(new->filenames[0], filename, PATH_MAX);
}

/* add new failure to user */
void add_failure(struct user * user, char * file){
	int file_exists = 0;
	if(!user->flagged){
		for(int i=0;i<8;i++){
			if(!strcmp(file, user->filenames[i])){
				file_exists = 1;
			}
		}
		if(!file_exists){
			user->access_fail++;
			memcpy(user->filenames[user->access_fail-1], file, PATH_MAX);
		}
	}
	if(user->access_fail == 8){
		user->flagged = 1;
	}
}