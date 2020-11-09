#ifndef _RSA_H
#define _RSA_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <fcntl.h>
#include <unistd.h>
#include <limits.h>

# define RSA_SIEVE_LIMIT 255
# define UL sizeof(size_t)


size_t exponent_mod(size_t b, size_t exp, size_t mod);

/*
 * Sieve of Eratosthenes Algorithm
 * https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
 *
 * arg0: A limit
 * arg1: The size of the generated primes list. Empty argument used as ret val
 *
 * ret:  The prime numbers that are less or equal to the limit
 */
int * sieve_of_eratosthenes(size_t *, size_t);


/*
 * Greatest Common Denominator
 *
 * arg0: first number
 * arg1: second number
 *
 * ret: the GCD
 */
int gcd(int , int);


/*
 * Calculates the modular inverse
 *
 * arg0: first number
 * arg1: second number
 *
 * ret: modular inverse
 */
size_t mod_inverse(size_t, size_t);


/*
 * Generates an RSA key pair and saves
 * each key in a different file
 */
void rsa_keygen(int);


/*
 * Encrypts an input file and dumps the ciphertext into an output file
 *
 * arg0: path to input file
 * arg1: path to output file
 * arg2: path to key file
 */
void rsa_encrypt(char *, char *, char *, int);


/*
 * Decrypts an input file and dumps the plaintext into an output file
 *
 * arg0: path to input file
 * arg1: path to output file
 * arg2: path to key file
 */
void rsa_decrypt(char *, char *, char *, int);


#endif /* _RSA_H */
