#include "utils.h"

/*
 * Prints the hex value of the input
 *
 * arg0: data
 * arg1: data len
 */
void print_hex(unsigned char *data, size_t len){
	size_t i;

	if (!data)
		printf("NULL data\n");
	else {
		for (i = 0; i < len; i++) {
		    if(!(i % 8) && (i!= 0))
		        printf(" ");
			if (!(i % 16) && (i != 0))
				printf("\n");
			printf("%02X ", data[i]);
		}
		printf("\n");
	}
}


/*
 * Prints the input as string
 *
 * arg0: data
 * arg1: data len
 */
void print_string(unsigned char *data, size_t len){
	size_t i;

	if (!data)
		printf("NULL data\n");
	else {
		for (i = 0; i < len; i++)
			printf("%c", data[i]);
		printf("\n");
	}
}


/*
 * Prints the usage message
 */
void usage(void){
	printf(
	    "\n"
	    "Usage:\n"
	    "    assign_3 -g \n" 
	    "    assign_3 -i in_file -o out_file -k key_file [-d | -e | -v]\n"
	    "    assign_3 -h\n"
	);
	printf(
	    "\n"
	    "Options:\n"
	    " -i    path    Path to input file\n"
	    " -o    path    Path to output file\n"
	    " -k    path    Path to key file\n"
	    " -d            Decrypt input and store results to output\n"
	    " -e            Encrypt input and store results to output\n"
	    " -g            Generates a keypair and saves to 2 files\n"
        " -v            Verbose                                 \n"
	    " -h            This help message\n"
	);
	exit(EXIT_FAILURE);
}


/*
 * Checks the validity of the arguments
 *
 * arg0: path to input file
 * arg1: path to output file
 * arg2: path to key file
 * arg3: operation mode
 */
void check_args(char *input_file, char *output_file, char *key_file, int op_mode){
	if ((!input_file) && (op_mode != 2)) {
		printf("Error: No input file!\n");
		usage();
	}

	if ((!output_file) && (op_mode != 2)) {
		printf("Error: No output file!\n");
		usage();
	}

	if ((!key_file) && (op_mode != 2)) {
		printf("Error: No user key!\n");
		usage();
	}

	if (op_mode == -1) {
		printf("Error: No mode\n");
		usage();
	}
}

int read_file(char * filename, unsigned char ** buffer){
    FILE * ifile;
    int filesize;

    if((ifile = fopen(filename, "rb")) == NULL){
        perror("Couldn't open filename");
        exit(EXIT_FAILURE);
    }

    fseek(ifile, 0, SEEK_END);
    filesize = ftell(ifile);
    rewind(ifile);

    *buffer = (unsigned char *)malloc(filesize);
    fread(*buffer, filesize, 1, ifile);
    fclose(ifile);
    return filesize;
}

void write_file(char * filename, unsigned char * buffer, int size){
    FILE * ofile;
    if((ofile = fopen(filename, "wb")) == NULL){
        perror("Couldn't open filename");
        exit(EXIT_FAILURE);
    }

    fwrite(buffer, size, 1, ofile);
    fclose(ofile);
}

