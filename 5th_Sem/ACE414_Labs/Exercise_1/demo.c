#include "stdio.h"
#include "string.h"
#include "stdlib.h"
#include "simple_crypto.h"

void OTP();
void caesar();
void vigenere();

int main(){
    OTP();
    caesar();
    vigenere();
    
    return 0;
}

void OTP(){
    /*
    * OTP part:
    * read a text of maximum size LENGTH and remove any characters not part of the 0-9/aA-zZ group
    * grab a random key the same size as the sanitized key
    * XOR each byte of the key with each byte of the text to encrypt it
    * same process to decrypt it
    * Outputs are printed in STDOUT
    ! encrypted output is outputted as HEX
    * cleanup before moving on the next crypto
    */

    char * plaintext = NULL;
    char * ciphertext = NULL;
    char * text = NULL;
    char * key = NULL;


    printf("[OTP] input: ");
    get_line(&text);
    // puts(text);

    text = sanitize(text);
    int key_size = strlen(text);

    key = (char *)malloc(key_size+1);

    get_key(key, key_size);

    ciphertext = xor_otp(text, key);

    printf("[OTP] encrypted: ");
    print_hex(ciphertext, key_size);

    plaintext = xor_otp(ciphertext, key);

    printf("[OTP] decrypted: %s\n", plaintext);
    
    free(text);
    free(key);
    free(plaintext);
    free(ciphertext);
}

void vigenere(){
    /*
     * Vigenere Part:
     * Reads a line from user
     * Reads a key from user
     * Creates the the keystream of the key by repeating it
     * Encrypt using the keystream
     * Decrypt using the keystream
     */

    char * key = NULL;
    char * text = NULL;
    char * plaintext = NULL;
    char * ciphertext = NULL;
    char * keystream = NULL;

    printf("[Vigenere] input: ");
    get_line(&text);
    printf("[Vigenere] key: ");
    get_line(&key);

    if(strlen(key) > strlen(text)){
        key[strlen(text)] = '\0';
        keystream = key;
    }else if(strlen(key) < strlen(text)) {
        keystream = (char *)malloc(strlen(text) + 1);
        memset(keystream, 0, strlen(text)+1);
        pad_key(key, keystream, strlen(text));
    }else{
        keystream = key;
    }

    ciphertext = vigenere_crypt(keystream, text);
    plaintext = vigenere_decrypt(keystream, ciphertext);

    printf("[Vigenere] encrypted: %s\n", ciphertext);
    printf("[Vigenere] decrypted: %s\n", plaintext);

    free(key);
    free(text);
    free(plaintext);
    free(ciphertext);
}

void caesar(){
    /*
     * Caesar Part:
     * Reads a line from user
     * Reads an integer from user specifying the key
     * Normalize Key into correct Length
     * Encrypt by shifting it
     ! Decrypt by shifting it by the complement of the Key
     */

    char * text = NULL;
    char * ciphertext = NULL;
    char * plaintext = NULL;

    int key = 0;

    printf("[Caesar] input: ");
    get_line(&text);

    printf("[Caesar] key: ");
    scanf("%d", &key);
    getchar();
    
    ciphertext = caesar_encrypt(text, key);
    plaintext = caesar_decrypt(ciphertext, key);
    printf("[Caesar] encrypted: %s\n", ciphertext);
    printf("[Caesar] decrypted: %s\n", plaintext);

    free(text);
    free(ciphertext);
    free(plaintext);
}
