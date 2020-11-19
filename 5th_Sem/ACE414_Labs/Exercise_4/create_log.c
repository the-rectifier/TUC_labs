#include <stdio.h>
#define LOGS 10

int main(){
    FILE * fp = fopen("file_logging.log", "w");

    char filenames[10][7] = {"file_0", "file_1",
			"file_2", "file_3", "file_4",
			"file_5", "file_6", "file_7",
			"file_8", "file_9"};

    for(int j=0;j<10;j++){
        for(int i=0;i<LOGS;i++){
            fprintf(fp,
            "%d\t%s\t%d\t%d\t%02d-%02d-%d\t%02d:%02d:%02d\t%s\n",
            j,filenames[i],1,1,69,69,69,69,69,69,"666420133769");
        }
    }
    fclose(fp);
}