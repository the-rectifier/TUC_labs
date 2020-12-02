#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>

#include "entry.h"

const char * get_ext(const char * filename){
	const char * suffix = strrchr(filename, '.');
	if(suffix == NULL || suffix == filename){
		return "";
	}
	return suffix;
}

int get_lines(FILE * fp){
	int lines = 0;
	char ch;
	
	while(!feof(fp)){
		ch = fgetc(fp);
		if(ch == '\n')
			lines++;
	}
	rewind(fp);
	return lines;
}

void list_all_crypted(FILE * fp){
	// const char delim[] = ".";
	// const char suffix[] = ".encrypt";
	int access_type;
	int lines = get_lines(fp);
	char path[PATH_MAX] = {0};
	int count = 0;

	for(int i=0;i<lines;i++){
		fscanf(fp,"%*d\t%s\t%*d\t%d\t%*02d-%*02d-%*d\t%*02d:%*02d:%*02d\t%*s\n",path, &access_type);
		if(!strcmp(get_ext(path), ".encrypt") && access_type == 0){
			count++;
			char * ptr = strtok(path, ".");
			while(ptr != NULL){
				if(strcmp(ptr, "encrypt"))
					printf("%s", ptr);
				ptr = strtok(NULL, ".");
			}
			putchar('\n');
		}	
	}
	printf("Total # of files encrypted: %d\n", count);
}

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

	int lines = get_lines(log);

	for(int i=0;i<lines;i++){
		fscanf(log,
            "%d\t%s\t%d\t%d\t%*02d-%*02d-%*d\t%*02d:%*02d:%*02d\t%*s\n",
            &uid,
            filename,
            &action_denied,
			&access_type);

		// printf("UID: %d\tFILENAME: %s\tACTION_DENIED: %d\tACCES_TYPE: %d\n",
		// uid,filename, action_denied, access_type);
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
	int uid;
	int access_denied;
	int access_type;
	int lines = 0;
	char filename[PATH_MAX] = {0};
	char fingerprint[MD5_DIGEST_LENGTH*2+1] = {0};
	char fingerprint_old[MD5_DIGEST_LENGTH*2+1] = {0};
	char * real_path = realpath(file_to_scan, NULL);

	struct user * mods = NULL;
	struct user * temp = NULL;
	
	lines = get_lines(log);

	for(int i=0;i<lines;i++){
		fscanf(log,
            "%d\t%s\t%d\t%d\t%*02d-%*02d-%*d\t%*02d:%*02d:%*02d\t%s\n",
            &uid,
            filename,
			&access_denied,
			&access_type,
            fingerprint);
		// puts(fingerprint);
		if(!strcmp(filename, real_path) && access_type && !access_denied && (strncmp(fingerprint_old, fingerprint, MD5_DIGEST_LENGTH*2+1))){
			/* File matches, also modded => log user and ++ its mods */
			/* Update new FP */
			// printf("UID: %d, FP: %s\n", uid, fingerprint);
			memcpy(fingerprint_old, fingerprint, MD5_DIGEST_LENGTH*2 +1);
			if(mods == NULL){
				temp = (struct user *)malloc(sizeof(struct user));
				temp->uid = uid;
				temp->mods = 1;
				temp->next = NULL;
				mods = temp;
			}else{
				/* Check for user and add to list if neccessary */
				temp = in_list(mods, uid);
				if(temp == NULL){
					temp = mods;
					while(temp->next != NULL){
						temp = temp->next;
					}
					temp->next = (struct user *)malloc(sizeof(struct user));
					temp->next->uid = uid;
					temp->next->mods = 1;
					temp->next->next = NULL;
				}else{
					temp->mods++;
				}
			}
		}
	}

	temp = mods;
	while(temp != NULL){
		printf("UID: %d\tMODS: %d\n", temp->uid,temp->mods);
		temp = temp->next;
	}
	while(mods != NULL){
		temp = mods->next;
		free(mods);
		mods = temp;
	}

	free(real_path);
	return;

}

void list_20_mins(FILE * log, int threshold){
	time_t time_now = time(NULL);
	time_t file_time;
	struct tm * file_time_tm = (struct tm *)malloc(sizeof(struct tm));
	int count = 0;

	int access_type;
	int action_denied;
	int day, month, year;
	int hour, min, sec;
	char filename[PATH_MAX] = {0};

	int lines = get_lines(log);

	for(int i=0;i<lines;i++){
		fscanf(log,
            "%*d\t%s\t%d\t%d\t%02d-%02d-%d\t%02d:%02d:%02d\t%*s\n",
			filename,
			&action_denied,
			&access_type,
			&day, &month, &year,
			&hour, &min, &sec);

		if(!action_denied && access_type == 0){
			file_time_tm->tm_mday = day;
			file_time_tm->tm_mon = month - 1;
			file_time_tm->tm_year = year - 1900;
			file_time_tm->tm_hour = hour;
			file_time_tm->tm_min = min;
			file_time_tm->tm_sec = sec;

			file_time = mktime(file_time_tm);
			if((difftime(time_now, file_time) / 60) <= 20){
				printf("%s\n", filename);
				count++;
			}
		}

	}

	free(file_time_tm);
	printf("Total files created in the last 20 mins: %d\n", count);
	if(count > threshold){
		printf("SUPICIOUS ACTIVITY\n");
	}

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

	while ((ch = getopt(argc, argv, "hi:mev:")) != -1) {
		switch (ch) {		
		case 'i':
			list_file_modifications(log, optarg);
			break;
		case 'm':
			list_unauthorized_accesses(log);
			break;
		case 'e':
			list_all_crypted(log);
			break;
		case 'v':
			list_20_mins(log, atoi(optarg));
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
	struct user * tmp = user;
    while(tmp != NULL){
        if(tmp->uid == key){
            return tmp;
        }
        tmp = tmp->next;
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
