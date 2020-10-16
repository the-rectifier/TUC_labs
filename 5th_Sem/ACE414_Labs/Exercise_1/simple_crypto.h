//
// Created by canopus on 10/12/20.
//
#include "stddef.h"

#define CUSTOM_ALPHABET_LENGTH 62

void get_key(char *, int);
char * encrypt_otp(char *, char *);
char * decrypt_otp(char *, char *);
char * caesar_encrypt(char *, int);
char * caesar_decrypt(char *, int);
void pad_key(char *, char * , int);
char * vigenere_crypt(char *, char *);
char * vigenere_decrypt(char *, char *);
void print_hex(char *);
char * sanitize(char *);
void get_line(char **);
