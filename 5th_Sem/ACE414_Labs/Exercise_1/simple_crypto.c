#define  _GNU_SOURCE

#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "assert.h"
#include "simple_crypto.h"

/*
 * Generates a random key of key_length size by reading key_length bytes from /dev/urandom
 * key contains only A-Z/a-z/0-9 characters
 */
void get_key(char * key_buffer, int key_length){
    
    FILE * random;
    random = fopen("/dev/urandom", "rb");
    for(int i=0;i<key_length;i++){
        key_buffer[i] = fgetc(random);
    }
    fclose(random);
    key_buffer[key_length+1] = '\0';
}

/*
 * XORs each byte of plaintext with each byte of Key
 */
char * encrypt_otp(char * plaintext, char * key){
    char * ciphertext = (char *)malloc(strlen(key)+1);
    memset(ciphertext, 0, strlen(key)+1);

    for(int i=0;i<strlen(key);i++){
        ciphertext[i] = (char) (plaintext[i] ^ key[i]);
    }
    return ciphertext;
}

/*
 * XORs each byte of plaintext with each byte of Key
 */
char * decrypt_otp(char * ciphertext, char * key){
    char * plaintext = (char *)malloc(strlen(key)+1);
    memset(plaintext, 0, strlen(key)+1);

    for(int i=0;i<strlen(key);i++){
        plaintext[i] = (char)(key[i] ^ ciphertext[i]);
    }
    return plaintext;
}

/*
 * Rotates each character Key spaces right based on this Alphabet
 * 0-9A-Za-z
 * supports cyclic key 62 -> 0, 63 -> 1, etc.
 * Checks the remaining distance until the next valid set and subtracts them form the key
 * Because the maximum length can transcend all 3 sets we need to shift in stages, calculating 
 * the shift of the next stage as well.
 ! The same logic applies for all 3 sets
 ! The same code is used for decryption using the complement of the key.
 ! Ex: shifting "a" by 4 -> "e", shifting "e" by 22 -> "a" 
 */
char * caesar_encrypt(char * text, int key){
    char * ciphertext = (char *)malloc(strlen(text)+1);
    memset(ciphertext, 0, strlen(text) + 1);
    key = key % CUSTOM_ALPHABET_LENGTH;
    int t_key;
    int diff;

    for(int i=0;i<strlen(text);i++){
        unsigned char text_char = (unsigned char) text[i];
        t_key = key;
        while(t_key > 0){
            if(text_char >= 'a' && text_char <= 'z'){
                if(text_char + t_key > 'z'){
                    diff = 'z' - text_char + 1;
                    t_key -= diff;
                    text_char = '0';
                }else{ 
                    text_char += t_key;
                    t_key = 0;
                }
            }else if(text_char >= 'A' && text_char <= 'Z'){
                if(text_char + t_key > 'Z'){
                    diff = 'Z' - text_char + 1;
                    t_key -= diff;
                    text_char += diff;
                    text_char += 6;
                }else{
                    text_char += t_key;
                    t_key = 0;
                }
            }else if(text_char >= '0' && text_char <= '9'){
                if(text_char + t_key > '9'){
                    diff = '9' - text_char + 1;
                    t_key -= diff;
                    text_char += diff;
                    text_char += 7;
                }else{
                    text_char += t_key;
                    t_key = 0;
                }
            }
        }
        ciphertext[i] = text_char;
    }

    return ciphertext;
}

/*
 * Normalizes the Key and then gets its complement 
 * Encrypting an already encrypted text with the complement results to the original
 */
char * caesar_decrypt(char * text, int key){
    return caesar_encrypt(text, CUSTOM_ALPHABET_LENGTH - (key % CUSTOM_ALPHABET_LENGTH));
}

/*
 * Creates Keystream buffer for the vigenere cipher by repeating each byte of key until
 * msg_length is reached
 */
void pad_key(char * key, char * keystream, int msg_length){
    for(int i=0,j=0;i<msg_length;i++, j++){
        if(j==strlen(key))
            j=0;
        keystream[i] = key[j];
    }
    
    assert(msg_length == strlen(keystream));
}

/*
 * Encrypts plaintext using the vigenere method and keystream
 */
char * vigenere_crypt(char * keystream, char * plaintext){
    char * ciphertext = (char *)malloc(strlen(plaintext)+1);
    memset(ciphertext, 0, strlen(plaintext)+1);

    for(int i=0;i<strlen(plaintext);i++){
        ciphertext[i] = (char)((plaintext[i] + keystream[i]) % 26) + 'A';
    }

    return ciphertext;
}

/*
 * Decrypts ciphertext using the vigenere method and keystream
 */
char * vigenere_decrypt(char * keystream, char * ciphertext){
    char * plaintext = (char *)malloc(strlen(ciphertext)+1);
    memset(plaintext, 0, strlen(ciphertext)+1);

    for(int i=0;i<strlen(ciphertext);i++){
        plaintext[i] = (char)((ciphertext[i] - keystream[i] + 26) % 26) + 'A';
    }

    return plaintext;
}

/*
 * Prints output 1 byte at a time in Hex format
 */
void print_hex(char * buffer, int size){
    for(int i=0;i<size;i++){
        if(buffer[i]==0){
            printf("00");
        }else{
            printf("%02hhX", buffer[i]);
        }
        fflush(stdout);
    }
    putchar('\n');
}

/*
 * Strips invalid characters for buffer
 */
char * sanitize(char * buffer){
    char * sanitized_out = (char *) malloc(strlen(buffer));
    for(int i=0,j=0;i<strlen(buffer);i++){
        int buffer_char = (unsigned char) buffer[i];
        if( (buffer_char >= 'A' && buffer_char <= 'Z') || (buffer_char >= 'a' && buffer_char <= 'z') || (buffer_char >= '0' && buffer_char <= '9')){
            sanitized_out[j] = (char)buffer_char;
            j++;
        }
    }
    free(buffer);
    return sanitized_out;
}

/* 
 * Reads a string of undefined length from STDIN and removes newline
 */
void get_line(char ** buffer){
    size_t size = 0;
    getline(buffer, &size, stdin);
    (*buffer)[strlen(*buffer)-1] = '\0';
}
