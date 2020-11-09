#include "rsa.h"
#include "utils.h"

/*
 * Modular exponentiation
 */
size_t exponent_mod(size_t b, size_t exp, size_t mod)
{
    size_t c = 1;

    if (mod == 1)
        return 0;
    for (size_t i = 1; i<= exp; i++)
        c = (c * b) % mod;
    return c;
}
/*
 * Sieve of Eratosthenes Algorithm
 * https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
 *
 * arg0: A limit
 * arg1: The size of the generated primes list. Empty argument used as ret val
 *
 * ret:  The prime numbers that are less or equal to the limit
 */
int * sieve_of_eratosthenes(size_t * array_size, size_t limit){
//    int limit = RSA_SIEVE_LIMIT;
    int no_primes=0;
    int array[limit];
    int * primes;
    int * t_primes;

    for(int i=0;i<limit;i++){
        array[i] = 1;
    }

     for(int i=2;i*i<=limit;i++){
         if(array[i] == 1){
             for(int j=i*i;j<=limit;j+=i) {
                 array[j] = 0;
             }
         }
     }

    for(int i=2;i<=limit;i++){
         if(array[i]){
            no_primes++;
         }
    }

    primes = (int *)malloc((no_primes+1)*sizeof(int));
    memset(primes, 0, (no_primes+1)*sizeof(int));

    t_primes = primes;

    for(int i=2;i<=limit;i++){
         if(array[i]){
             *t_primes = i;
             t_primes++;
         }
    }

//    for(int i=0;i<no_primes;i++){
//        printf("%d ", *(primes+i));
//    }
    *array_size = no_primes;
    return primes;

}


/*
 * Greatest Common Denominator
 *
 * arg0: first number
 * arg1: second number
 *
 * ret: the GCD
 */
int gcd(int a, int b){
    if(!b)
        return a;
    else
        return gcd(b, a % b);
}


/*
 * Calculates the modular inverse
 *
 * arg0: first number
 * arg1: second number
 *
 * ret: modular inverse
 */
size_t mod_inverse(size_t a, size_t b){
    a = a%b;
    for (size_t x=1; x<b; x++) {
        if ((a * x) % b == 1){
            return x;
        }
    }
    return 0;
}


/*
 * Generates an RSA key pair and saves
 * each key in a different file
 */
void rsa_keygen(int verbose){
    unsigned char * priv = (unsigned char *) "private.key";
    unsigned char * pub = (unsigned char *) "public.key";
    unsigned char out[UL*2] = {};

    int * prime_pool;
    int rand_q_index;
    int rand_p_index;

    size_t pool_size;
    size_t p;
    size_t q;
    size_t n;
    size_t phi_n;
    size_t e;
    size_t d;

    srand(time(NULL));

    prime_pool = sieve_of_eratosthenes(&pool_size, RSA_SIEVE_LIMIT);

    rand_p_index = (rand() % (int)pool_size);
    rand_q_index = (rand() % (int)pool_size);

    while(rand_p_index == rand_q_index){
        rand_q_index = rand() % pool_size;
    }

	p = prime_pool[rand_p_index];
	q = prime_pool[rand_q_index];
	n = p*q;
	phi_n = (p-1)*(q-1);

	e = 3;
    for(int i=0;i<RSA_SIEVE_LIMIT;i++){
        if(i==rand_q_index||i==rand_p_index)
            continue;
        if((prime_pool[i] % phi_n != 0) && gcd(prime_pool[i],phi_n) == 1){
            e = prime_pool[i];
            break;
        }
    }

	d = mod_inverse(e,phi_n);

    memcpy(out, &n, UL);
    memcpy(out+UL, &e, UL);
    write_file((char *)priv, out, UL*2);
    memcpy(out+UL, &d, UL);
    write_file((char *)pub, out, UL*2);

    if(verbose){
        printf("Leaking RSA components: \n"
               "p = %zu\n"
               "q = %zu\n"
               "n = %zu\n"
               "e = %zu\n"
               "d = %zu\n",
               p,q,n,e,d);
    }

    free(prime_pool);

}


/*
 * Encrypts an input file and dumps the ciphertext into an output file
 *
 * arg0: path to input file
 * arg1: path to output file
 * arg2: path to key file
 */
void rsa_encrypt(char *input_file, char *output_file, char *key_file, int verbose){
    FILE * fp;
    unsigned char * msg = NULL;
    unsigned char buffer[UL*2] = {};
    size_t n;
    size_t e;

    // Read key and produce n,e
	if((fp = fopen(key_file, "rb")) == NULL){
	    perror("Couldn't open file");
	    exit(EXIT_FAILURE);
    }

	fread(buffer, UL*2, 1, fp);
	fclose(fp);

	memcpy((unsigned char *)&n, buffer, UL);
	memcpy((unsigned char *)&e, buffer+UL, UL);

	// read file and allocate UL bytes for each byte of file
	int filesize = read_file(input_file, &msg);
    size_t * ciphertext = (size_t *)malloc(UL*filesize);

    // encrypt
    for(int i=0;i<filesize;i++) {
        *(ciphertext+i) = exponent_mod(*(msg + i), e, n);
    }

    // write output
    write_file(output_file, (unsigned char *)ciphertext, filesize*UL);

    if(verbose){
        puts("Leaking RSA encyption: ");
        puts("Key:");
        print_hex(buffer, UL*2);
        puts("Read text from file: ");
        print_string(msg, filesize);
        puts("Resulting Ciphertext:");
        print_hex((unsigned char *) ciphertext, UL * filesize);
    }

    // free resources
    free(msg);
    free(ciphertext);
}


/*
 * Decrypts an input file and dumps the plaintext into an output file
 *
 * arg0: path to input file
 * arg1: path to output file
 * arg2: path to key file
 */
void rsa_decrypt(char *input_file, char *output_file, char *key_file, int verbose){
    unsigned char buffer[UL*2] = {0};
    unsigned char * msg = NULL;
    FILE *fp;
    size_t * ciphertext = NULL;
    size_t n;
    size_t d;
    size_t cipher_chunk;
    size_t msg_chunk;

    int cipherlen;

    if((fp = fopen(key_file, "rb")) == NULL){
        perror("Couldn't open file");
        exit(EXIT_FAILURE);
    }

    fread(buffer, UL*2, 1, fp);
    memcpy((unsigned char *)&n, buffer, UL);
    memcpy((unsigned char *)&d, buffer+UL, UL);


    cipherlen = read_file(input_file, (unsigned char **)&ciphertext);
    msg = (unsigned char *)malloc(cipherlen/UL);

    for(int i=0;i<cipherlen/UL;i++){
        cipher_chunk = *(ciphertext+i);
//        print_hex((unsigned char *) &cipher_chunk, UL);
        msg_chunk = (unsigned char) exponent_mod(cipher_chunk, d, n);
        msg[i] = msg_chunk;
//        printf("%02X", (unsigned char) msg_chunk);
    }

    if(verbose){
        puts("Leaking RSA Decryption: ");
        puts("Key:");
        print_hex(buffer, UL*2);
        puts("Rread Ciphertext:");
        print_hex((unsigned char *) ciphertext, cipherlen);
        puts("Resulting Plaintext: ");
        print_string(msg, cipherlen/UL);
    }

    write_file(output_file, msg, cipherlen/UL);
    free(ciphertext);
    free(msg);
}