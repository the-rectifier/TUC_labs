#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <openssl/evp.h>
#include <openssl/err.h>
#include <openssl/conf.h>
#include <openssl/cmac.h>


#define BLOCK_SIZE 16


/* function prototypes */
void print_hex(unsigned char *, size_t);
void print_string(unsigned char *, size_t);
void usage(void);
void check_args(char *, char *, unsigned char *, int, int);
void keygen(unsigned char *, unsigned char *,int, int);
void prep_decrypt(char *, char *, unsigned char *, int, int);
void prep_encrypt(char *, char *, unsigned char *, int, int);
void handleErrors(void);
int decrypt(unsigned char *, int, unsigned char *, unsigned char *, int);
int encrypt(unsigned char *, int, unsigned char *, unsigned char *, int);
int read_file(char *, unsigned char **);
void write_file(char *, unsigned char *, int);
void gen_CMAC(int, unsigned char *, unsigned char *, int, unsigned char *, size_t *);
void sign(char *, char *, unsigned char *, int, int);
void verify(char *, char *, unsigned char *, int, int);
int verify_CMAC(unsigned char *, unsigned char *);


/*
 * Prints the hex value of the input
 * Just like a Hexdump
 * 8 bytes per side
 * 16 values per line
 */
void print_hex(unsigned char *data, size_t len)
{
    size_t i;

    if (!data)
        printf("NULL data\n");
    else {
        for (i = 0; i < len; i++) {
            // print like hexdump
            if (!(i % 8) && (i != 0))
                printf(" ");
            if (!(i % 16) && (i != 0))
                printf("\n");
            printf("%02X ", data[i]);
        }
        printf("\n");
    }
}

/*
 * Read every Byte from filename and stores them in *buffer
 * The buffer is malloc'd here
 * Caller has to free it
 * Returns bytes read
 */
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

/*
 * Writes size bytes from buffer to filename
 */
void write_file(char * filename, unsigned char * buffer, int size){
    FILE * ofile;
    if((ofile = fopen(filename, "wb")) == NULL){
        perror("Couldn't open filename");
        exit(EXIT_FAILURE);
    }

    fwrite(buffer, size, 1, ofile);
    fclose(ofile);
}

/*
 * Error Handler for EVP API
 */
void handleErrors(void)
{
    ERR_print_errors_fp(stderr);
    abort();
}

/*
 * Prints the input as string
 */
void print_string(unsigned char *data, size_t len)
{
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
 * Describe the usage of the new arguments you introduce
 */
void usage(void) {
    printf(
            "\n"
            "Usage:\n"
            "    assign_1 -i in_file -o out_file -p passwd -b bits"
            " [-d | -e | -s | -v | -V]\n"
            "    assign_1 -h\n"
    );
    printf(
            "\n"
            "Options:\n"
            " -i    path    Path to input file\n"
            " -o    path    Path to output file\n"
            " -p    psswd   Password for key generation\n"
            " -b    bits    Bit mode (128 or 256 only)\n"
            " -d            Decrypt input and store results to output\n"
            " -e            Encrypt input and store results to output\n"
            " -s            Encrypt+sign input and store results to output\n"
            " -v            Decrypt+verify input and store results to output\n"
            " -V            Verbose\n"
            " -h            This help message\n"
    );
    exit(EXIT_FAILURE);
}

/*
 * Checks the validity of the arguments
 * Check the new arguments you introduce
 */
void check_args(char *input_file, char *output_file, unsigned char *password, int bit_mode, int op_mode){
    if (!input_file) {
        printf("Error: No input file!\n");
        usage();
    }

    if (!output_file) {
        printf("Error: No output file!\n");
        usage();
    }

    if (!password) {
        printf("Error: No user key!\n");
        usage();
    }

    if ((bit_mode != 128) && (bit_mode != 256)) {
        printf("Error: Bit Mode <%d> is invalid!\n", bit_mode);
        usage();
    }

    if (op_mode == -1) {
        printf("Error: No mode\n");
        usage();
    }
}

/*
 * Generates a key using a password
 */
void keygen(unsigned char *password, unsigned char *key, int bit_mode, int v){
    const EVP_CIPHER *cipher;
    const EVP_MD * dgst = EVP_sha1();

    if(!dgst){
        perror("Couldn't find digest");
        exit(EXIT_FAILURE);
    }

    if(bit_mode == 128){cipher = EVP_aes_128_ecb();}
    else {cipher = EVP_aes_256_ecb();}

    if(!cipher){
        perror("Couldn't find cipher");
        exit(EXIT_FAILURE);
    }

//     ECB mode doesnt need IV, Null it
    if(!EVP_BytesToKey(cipher, dgst, NULL, password, strlen((char *)password), 1, key, NULL)){
        perror("Couldn't derive password");
    }

    if(v){
        puts("\nKey: ");
        print_hex(key, bit_mode/8);
    }
}

/*
 * Preapare encryption
 * Read file, allocate segments encrypt then write
 */
void prep_encrypt(char * i_file, char * o_file, unsigned char * key, int bit_mode, int v){
    int ciphertext_len;
    int plaintext_len;

    unsigned char * plaintext = NULL;
    unsigned char * ciphertext = NULL;


    plaintext_len = read_file(i_file, &plaintext);

//     Allocate twice the size of the read text, just in case (for padding)
//     init it w/ null bytes
    ciphertext = (unsigned char *)malloc(plaintext_len + BLOCK_SIZE);
    memset(ciphertext, 0, plaintext_len + BLOCK_SIZE);

    ciphertext_len = encrypt(plaintext, plaintext_len, key, ciphertext, bit_mode);

    if(v){
        puts("\nPlaintext: ");
        print_string(plaintext, plaintext_len);
        puts("\nHexdump of encryption: ");
        print_hex(ciphertext, ciphertext_len);
    }

    write_file(o_file, ciphertext, ciphertext_len);

//     Free the resources and return
    free(plaintext);
    free(ciphertext);
}

/*
 * Encrypts plaintext_len bytes of plaintext with key using bit_mode and stores them into ciphertext
 */
int encrypt(unsigned char * plaintext, int plaintext_len, unsigned char * key, unsigned char * ciphertext, int bit_mode) {
//    Create the object
    EVP_CIPHER_CTX *ctx;

    int len;
    int ciphertext_len;

    // Specify ECB mode
    const EVP_CIPHER *mode;

    if(bit_mode == 128){mode = EVP_aes_128_ecb();}
    else {(mode = EVP_aes_256_ecb());}

    // Init the Object
    if (!(ctx = EVP_CIPHER_CTX_new())) {
        handleErrors();
    }

    if (1 != EVP_EncryptInit_ex(ctx, mode, NULL, key, NULL))
        handleErrors();

    // Encrypt up until the last block
    if(1 != EVP_EncryptUpdate(ctx, ciphertext, &len, plaintext, plaintext_len))
        handleErrors();
    ciphertext_len = len;

    // Finalize encryption
    if(1 != EVP_EncryptFinal_ex(ctx, ciphertext + len, &len))
        handleErrors();
    ciphertext_len += len;

    // Free resources and return
    EVP_CIPHER_CTX_free(ctx);

    return ciphertext_len;
}

/*
 * Prepare decryption
 * Same for encryption
 */
void prep_decrypt(char * i_file, char * o_file, unsigned char * key, int bit_mode, int v){
    int plaintext_len;
    int ciphertext_len;

    unsigned char * plaintext = NULL;
    unsigned char * ciphertext = NULL;

    ciphertext_len = read_file(i_file, &ciphertext);
    plaintext = (unsigned char *)malloc(ciphertext_len);
    memset(plaintext, 0, ciphertext_len);
    plaintext_len = decrypt(ciphertext, ciphertext_len, key, plaintext, bit_mode);

    if(v){
        puts("\nHexdump of ciphertext:");
        print_hex(ciphertext, ciphertext_len);
        puts("\nString output of decryption:");
        print_string(plaintext, plaintext_len);
    }
    write_file(o_file, plaintext, plaintext_len);

    free(plaintext);
    free(ciphertext);
}

/*
 * Generates a 16 byte long, CMAC value from buffer and stores it into cmac, and its length to cmac_len
 */
void gen_CMAC(int bit_mode, unsigned char * key, unsigned char * buffer, int buffer_len, unsigned char * cmac, size_t * cmac_len){
    CMAC_CTX *ctx;

    const EVP_CIPHER *mode;
    if(bit_mode == 128){mode = EVP_aes_128_ecb();}
    else {(mode = EVP_aes_256_ecb());}

    if(!(ctx = CMAC_CTX_new()))
        handleErrors();

    if(1 != (CMAC_Init(ctx, key, bit_mode/8, mode, NULL)))
        handleErrors();

    if(1 != (CMAC_Update(ctx, buffer, buffer_len)))
        handleErrors();

    if(1 != (CMAC_Final(ctx, cmac, cmac_len)))
        handleErrors();

    CMAC_CTX_free(ctx);
}

/*
 * Encrypts data from i_file using bit_mode and key, signs it and stores it into o_file
 * output <- Ciphertext + tag
 */
void sign(char * i_file, char * o_file, unsigned char * key, int bit_mode, int v){
    // Same procedure but we append the generated CMAC at the end of ciphertext before writing
    int plaintext_len;
    int ciphertext_len;
    size_t cmac_len;

    unsigned char cmac[BLOCK_SIZE];
    unsigned char * plaintext = NULL;
    unsigned char * ciphertext = NULL;

    plaintext_len = read_file(i_file, &plaintext);

    ciphertext = (unsigned char *)malloc(plaintext_len + BLOCK_SIZE);
    memset(ciphertext, 0, plaintext_len + BLOCK_SIZE);

    // Encrypt
    ciphertext_len = encrypt(plaintext, plaintext_len, key, ciphertext, bit_mode);

    // Generate CMAC
    gen_CMAC(bit_mode, key, plaintext, plaintext_len, cmac, &cmac_len);

    // Allicate ouput buffer and copy ciphertext and tag to it
    unsigned char * out = (unsigned char *)malloc(ciphertext_len + cmac_len);
    memcpy(out, ciphertext, ciphertext_len);
    memcpy(out+ciphertext_len, cmac, cmac_len);

    if(v){
        puts("\nPlaintext:");
        print_string(plaintext, plaintext_len);
        puts("\nHexdump of encryption");
        print_hex(ciphertext, ciphertext_len);
        puts("\nGenerated CMAC: ");
        print_hex(cmac, cmac_len);
    }
    // Write to file
    write_file(o_file, out, ciphertext_len + cmac_len);

    free(plaintext);
    free(ciphertext);
    free(out);
}

/*
 * Check if cmac1 equals cmac2
 * returns 1 if so, otherwise 0
 */
int verify_CMAC(unsigned char * cmac1, unsigned char * cmac2){
    if(strncmp((char *)cmac1, (char *)cmac2, BLOCK_SIZE) == 0)
        return 1;
    else
        return 0;
}

/*
 * Reads ciphertext for i_file, decrypts it and verifies it agaisnt the calculated CMAC
 */
void verify(char * i_file, char * o_file, unsigned char * key, int bit_mode, int v){
    int plaintext_len;
    int ciphertext_len;
    int in_size;
    size_t cmac_len = BLOCK_SIZE;
    size_t cmac_len_f;

    unsigned char * in = NULL;
    unsigned char * plaintext = NULL;
    unsigned char * ciphertext = NULL;

    unsigned char cmac[BLOCK_SIZE];
    unsigned char cmac_f[BLOCK_SIZE];

    in_size = read_file(i_file, &in);

    // Ciphertext is cmac_len (16) bytes less that the whole text
    ciphertext_len = in_size - cmac_len;

    ciphertext = (unsigned char *)malloc(ciphertext_len);
    memset(ciphertext, 0, ciphertext_len);

    plaintext = (unsigned char *)malloc(ciphertext_len);
    memset(plaintext, 0, ciphertext_len);

    // Copy ciphertext and provided CMAC
    memcpy(ciphertext, in, ciphertext_len);
    memcpy(cmac,in+ciphertext_len, cmac_len);

    // Decrypt the text
    plaintext_len = decrypt(ciphertext, ciphertext_len, key, plaintext, bit_mode);

    // Calculate new CMAC
    gen_CMAC(bit_mode, key, plaintext, plaintext_len, cmac_f, &cmac_len_f);

    if(v){
        puts("\nHexdump of ciphertext: ");
        print_hex(ciphertext, ciphertext_len);
        puts("\nResulting Plaintext: ");
        print_string(plaintext, plaintext_len);
        puts("\nShipped CMAC: ");
        print_hex(cmac, cmac_len);
        puts("\nCalculated CMAC: ");
        print_hex(cmac_f, cmac_len_f);
    }
    // Check whether they match
    if(verify_CMAC(cmac, cmac_f)){
        write_file(o_file, plaintext, plaintext_len);
        if(v){
            puts("CMACs Match!");
        }
    }else{
        puts("Could not Authenticate MAC!");
    }

    // Cleanup and exit
    free(in);
    free(ciphertext);
    free(plaintext);
}

int decrypt(unsigned char * ciphertext, int ciphertext_len, unsigned char * key, unsigned char * plaintext, int bit_mode){
    // The exact reverse process from ecrypting
    EVP_CIPHER_CTX *ctx;

    int len;
    int plaintext_len;

    const EVP_CIPHER *mode;
    if(bit_mode == 128){mode = EVP_aes_128_ecb();}
    else {(mode = EVP_aes_256_ecb());}

    if(!(ctx = EVP_CIPHER_CTX_new()))
        handleErrors();

    if(1 != EVP_DecryptInit_ex(ctx, mode, NULL, key, NULL))
        handleErrors();

    if(1 != EVP_DecryptUpdate(ctx, plaintext, &len, ciphertext, ciphertext_len))
        handleErrors();

    plaintext_len = len;

    if(1 != EVP_DecryptFinal(ctx, plaintext+len, &len))
        handleErrors();

    plaintext_len += len;

    EVP_CIPHER_CTX_free(ctx);
    return plaintext_len;
 }

/*
 * Encrypts the input file and stores the ciphertext to the output file
 *
 * Decrypts the input file and stores the plaintext to the output file
 *
 * Encrypts and signs the input file and stores the ciphertext concatenated with
 * the CMAC to the output file
 *
 * Decrypts and verifies the input file and stores the plaintext to the output
 * file
 */
int main(int argc, char **argv){
    int opt;			/* used for command line arguments */
    int bit_mode;			/* defines the key-size 128 or 256 */
    int op_mode;			/* operation mode */
    int verbose;
    char * input_file;		/* path to the input file */
    char * output_file;		/* path to the output file */
    unsigned char * password;	/* the user defined password */

    /* Init arguments */
    input_file = NULL;
    output_file = NULL;
    password = NULL;
    bit_mode = -1;
    op_mode = -1;
    verbose = 0;
    /*
     * Get arguments
     */
    while ((opt = getopt(argc, argv, "b:i:o:p:desvh:V")) != -1) {
        switch (opt) {
            case 'b':
                bit_mode = atoi(optarg);
                break;
            case 'i':
                input_file = strdup(optarg);
                break;
            case 'o':
                output_file = strdup(optarg);
                break;
            case 'p':
                password = (unsigned char *)strdup(optarg);
                break;
            case 'd':
                /* if op_mode == 1 the tool decrypts */
                op_mode = 1;
                break;
            case 'e':
                /* if op_mode == 1 the tool encrypts */
                op_mode = 0;
                break;
            case 's':
                /* if op_mode == 1 the tool signs */
                op_mode = 2;
                break;
            case 'v':
                /* if op_mode == 1 the tool verifies */
                op_mode = 3;
                break;
            case 'V':
                verbose = 1;
                break;
            case 'h':
            default:
                usage();
        }
    }


    /* check arguments */
    check_args(input_file, output_file, password, bit_mode, op_mode);
    unsigned char key[bit_mode/8];
    keygen(password, key, bit_mode, verbose);

    switch(op_mode){
        case 0:
            prep_encrypt(input_file, output_file, key, bit_mode, verbose);
            break;
        case 1:
            prep_decrypt(input_file, output_file, key, bit_mode, verbose);
            break;
        case 2:
            sign(input_file, output_file, key, bit_mode, verbose);
            break;
        case 3:
            verify(input_file, output_file, key, bit_mode, verbose);
            break;
    }


    free(input_file);
    free(output_file);
    free(password);

    /* END */
    return 0;
}
