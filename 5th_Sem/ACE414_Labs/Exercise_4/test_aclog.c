#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>


int main(){
	int i;
	FILE *file;
	char * junk = "junk junk junk";

	char filenames[10][7] = {"file_0", "file_1",
			"file_2", "file_3", "file_4",
			"file_5", "file_6", "file_7",
			"file_8", "file_9"};


	/* Create all the files */
	for(i = 0; i < 10; i++){
		file = fopen(filenames[i], "w+");
		if(file == NULL)
			printf("fopen error\n");
		else{
			fwrite(filenames[i], strlen(filenames[i]), 1, file);
			fclose(file);
		}
	}
	
	/* access file_0 and file_1 10 times with no permissions */
	/* Expecting to see 20 denied access logs*/
	chmod(filenames[0], 0);
	chmod(filenames[1], 0);
	for(int i=0;i<10;i++){
		file = fopen(filenames[0], "r");
		file = fopen(filenames[1], "r");
	}

	/* edit file_2 and file_3 10 times */
	/** Expecting 12 hash changes
	 * 1 for the open with write
	 * 10 for the writing
	 * 1 for the write at the end
	*/
	file = fopen(filenames[2], "w");
	for(int i=0;i<10;i++){
		fwrite(junk, strlen(junk)-1, 2, file);
	}
	fwrite(junk, strlen(junk), 1, file);
	fclose(file);

	/* same as above */
	file = fopen(filenames[3], "w");
	for(int i=0;i<10;i++){
		fwrite(junk, strlen(junk)-1, 1, file);
	}
	fwrite(junk, strlen(junk), 1, file);
	fclose(file);

	/* read file_4 */

	file = fopen(filenames[4], "r");
	char buffer[1024];
	fread(buffer, 69, 1, file);
	fclose(file);

	/* appent */
	/* should see empty hash */
	/* 1 hash change */
	file = fopen(filenames[5], "a");
	fwrite(junk, strlen(junk)-1, 2, file);
	fclose(file);

	return 0;
}
