# Exercise 2: Simple AES ECB (Oh God... :cold_sweat:) Implementation in C

Technical University of Crete
---
ACE414 - Security of Systems and Services
---

### First of all, nobody uses ECB, ever!
### Now that this is out of the way...

## Usage:

After running `make` you should end up with an executable named `assign2`

```
./assign2 -i input_file -o output_file -p password -b bits [-d | -e | -s | -v | -V]

Options:
    -i  Required    Input file
    -o  Required    Output file
    -p  Required    Password
    -b  Required    Bit Mode 128 or 256
    -e  Optional*   Encrypt Mode
    -d  Optional*   Decrypt Mode
    -s  Optional*   Encrypt and Sign with CMAC
    -v  Optional*   Decrypt and Verify with CMAC  
    -V  Optional    Verbose output
    -h  Optional    This help message

    *Only one of those
```

- Notes: 
  - Please make sure you have `openssl` installed
  - Every operation results in output which is stored in the file specified by the `-o` argument
---

## Implementation details

- The tool uses the [EVP API](https://wiki.openssl.org/index.php/EVP) which provides a high level interface to OpenSSL's cryptographic functions and operations
  
### Key Derivation:
- It's done using the [BytesToKey](https://www.openssl.org/docs/man1.1.1/man3/EVP_BytesToKey.html) function, a provided string from the user as passphrase and the chosen key size 128/256 bits.
- An appropriate destination cipher is used based on the provided key size
- Default Digest function is changed from `MD5` to `SHA1`
- Since ECB is used, there is no need to generate an IV

### Encryption/Decryption:
- Encryption and Decryption are done using the appropriate functions for each operation. [Example](https://wiki.openssl.org/index.php/EVP_Symmetric_Encryption_and_Decryption) from the not so helpful wiki. The [man](https://www.openssl.org/docs/man1.1.1/man3/EVP_CIPHER_CTX_new.html) pages are just a tiny bit better thought.
- Firstly the key is generated
- For each operation, respectively, the input is read and stored in a buffer
- The requested operation is performed and the result is stored in the output

### Signing:
- For Signing, the CMAC algorithm is used along with the [interface](https://man.openbsd.org/CMAC_Init) to set it up
- For Signing, the same process is used as for Encrypting, however, before writing the output to the file, a CMAC (16 bytes in length) is calculated using the plaintext and the key.
- Everything then is copied into a larger output buffer (ciphertext then the CMAC) to accomodate both, and then written into the output.

### Verification:
- For Verifying the CMAC, the tool reads the input file and seperates the ciphertext from the CMAC
- After decrypting the ciphertext, it calculates a new CMAC 
- It compares the new CMAC against the shipped one and only IF they match, the plaintext will be written to output.

### Implementation Notes:
- If User has set the -V (verbose) option, then the tool will print out info about each stage of the current operation.
- That includes:   
  - Hexdump of the Key
  - Hexdump of the ciphertext generated or read
  - String output of the plaintext generated or read
  - Generated CMAC
  - Calculated CMAC
  - Verification assertion
  - `-V` should be used with care


## Documentation:
- [OpenSSL wiki](https://wiki.openssl.org/)
- [OpenSSL man Pages](https://www.openssl.org/docs/man1.1.1/)
- [CMAC man from OpenBSD](https://man.openbsd.org/CMAC_Init)
- :duck::duck::runner:

