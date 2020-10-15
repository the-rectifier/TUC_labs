//
// Created by canopus on 10/12/20.
//
#include "stddef.h"

#define CUSTOM_ALPHABET_LENGTH 62

void get_key(char *, int);
char * encrypt(const char *, char *);
char * dcrypt(const char *, char *);
char * caesar_dew_it(const char *, int);
void pad_key(char *, char * , int);
char * vigenere_crypt(const char *, char *);
char * vigenere_decrypt(const char *, char *);
void print_hex(char *);
char * sanitize(char *);
void get_line(char **);