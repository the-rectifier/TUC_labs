#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#define LOGS 10
#define USERS 10
#define LOG_FILE "file_logging.log"

int main(){
	FILE *file;

	char junk_1[] = "junk_1";
	char junk_2[] = "junk_2";
	char test_append[] = "Nickelback best metal out there \\m/";

	char filenames[10][7] = {"file_0", "file_1",
			"file_2", "file_3", "file_4",
			"file_5", "file_6", "file_7",
			"file_8", "file_9"};

	char tinki[10][69] = {"Gojira", "LOG", "Behemoth", "Megadeth", "Tool", "Trivium", "Godsmack", "Architects", "FUCCCCCCKING SLAAAAAYERRRR", "BLS"};
	// /* Create all the files */
	for(int i=0;i<10;i++){
		file = fopen(filenames[i], "w+");
		if(file == NULL)
			printf("fopen error\n");
		else{
			fwrite(filenames[i], strlen(filenames[i]), 1, file);
			fclose(file);
		}
	}



	/**
	 * Create 2 burner files and nuke their permissions
	 * Try to access them should give access denied
	 * * PASS *
	 */
	file = fopen(junk_1, "w+");
	if(file != NULL){
		fprintf(file, "JUNK_1");
		fclose(file);
	}

	file = fopen(junk_2, "w+");
	if(file != NULL){
		fprintf(file, "JUNK_2");
		fclose(file);
	}

	chmod(junk_1, 0);
	chmod(junk_2, 0);
	
	for(int i=0;i<2;i++){
		file = fopen(junk_1, "r");
		if(file != NULL)
			fclose(file);
		file = fopen(junk_2, "r");
		if(file != NULL)
			fclose(file);
	}

	/** 
	 * Expecting 12 hash changes
	 * 1 for the open with write => empty file HASH
	 * 10 for the writing
	 * 1 for the write at the end
	 * * PASS *
	*/
	file = fopen(filenames[2], "w");
	for(int i=0;i<10;i++){
		fwrite(tinki[i], strlen(tinki[i]), 2, file);
	}
	fwrite(tinki[0], strlen(tinki[0]), 1, file);
	fclose(file);

	/**
	 * Normal file opening
	 */
	file = fopen(filenames[4], "r");
	fclose(file);

	/**
	 * Check the append mode
	 */
	file = fopen(filenames[2], "a");
	fwrite(test_append, sizeof(test_append), 1, file);
	fclose(file);

	/** 
	 * Generate logs to avoid simulating other users and their permissions
	 * Provided that the logs are generated correctly (tested above)
	 */
	file = fopen(LOG_FILE, "a");
	/** 
	 * Create 100 logs 
	 * 10 users denied access to 10 files
	 * Check for maliciuous users
	 * All 10 should be
	 * user 666 should not
	*/
	for(int j=0;j<USERS;j++){
        for(int i=0;i<LOGS;i++){
            fprintf(file,
            "%d\t%s\t%d\t%d\t%02d-%02d-%d\t%02d:%02d:%02d\t%s\n",
            j,filenames[i],1,1,69,69,69,69,69,69,"Gojira");
        }
    }
	fprintf(file,
            "%d\t%s\t%d\t%d\t%02d-%02d-%d\t%02d:%02d:%02d\t%s\n",
            666,filenames[0],1,1,69,69,69,69,69,69,"Gojira");
	
	/**
	 * Create 100 logs
	 * 10 users edit 2 files 10 times
	 * Just changing the hashing will do 
	 * Should see every UID with 10 edits next to it
	 */
	for(int j=0;j<USERS;j++){
        for(int i=0;i<LOGS;i++){
            fprintf(file,
            "%d\t%s\t%d\t%d\t%02d-%02d-%d\t%02d:%02d:%02d\t%s\n",
            j,filenames[8],0,2,69,69,69,69,69,69,tinki[i]);
			fprintf(file,
            "%d\t%s\t%d\t%d\t%02d-%02d-%d\t%02d:%02d:%02d\t%s\n",
            j,filenames[9],0,2,69,69,69,69,69,69,tinki[i]);
        }
    }
	return 0;
}
