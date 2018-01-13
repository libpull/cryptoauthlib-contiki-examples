#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "contiki.h"
#include "cryptoauthlib.h"
#include "sample_data.h"

PROCESS(runner, "Runner For CryptoAuthenticator");
AUTOSTART_PROCESSES(&runner);

int try = 10;
ATCA_STATUS status;

void test_serial() {
    uint8_t serial[9];
    status = atcab_read_serial_number(serial);
    if (status != ATCA_SUCCESS) {
        printf("read_serial failed\n");
        return;
    }
    printf("Serial-number is %#x %#x %#x %#x\n", 
            serial[0], serial[1], serial[2], serial[3]);
}

void test_digest() {
    uint8_t hash[ATCA_SHA2_256_DIGEST_SIZE];
    atca_sha256_ctx_t ctx;
    status = atcab_hw_sha2_256_init(&ctx);
    if (status != ATCA_SUCCESS) {
        printf("Error in sha init\n");
        return;
    }
    status = atcab_hw_sha2_256_update(&ctx, data_g, 128);
    if (status != ATCA_SUCCESS) {
        printf("Error in sha update\n");
        return;
    }
    status = atcab_hw_sha2_256_finish(&ctx, hash);
    if (status != ATCA_SUCCESS) {
        printf("Error in sha finish\n");
        return;
    }
    int result = memcmp(hash, hash_g, 32);
    printf("Digest calculation: %s\n", result == 0? "success": "failed");
}

void test_ecdsa() {
    /* Verify the pre calculated hash */
    bool is_verified = true;
    status = atcab_verify_extern(hash_g, sig_g, pub_g, &is_verified);
    if (status != ATCA_SUCCESS) {
        printf("Error in verify extern\n");
        return;
    }
    printf("Verification %s\n", is_verified == true? "passed":"failed");
}

PROCESS_THREAD(runner, ev, data)
{
    PROCESS_BEGIN();
    do {
        /* Test the SHA204a */
        status = atcab_init(&cfg_atsha204a_i2c_default);
        if (status != ATCA_SUCCESS) {
            printf("Init failed\n");
            break;
        }
        test_serial();
        test_digest();
        /* Test the ECC508a */
        status = atcab_init(&cfg_ateccx08a_i2c_default);
        if (status != ATCA_SUCCESS) {
            printf("Init failed\n");
            break;
        }
        test_serial();
        test_digest();
        test_ecdsa();
    } while(0);
    /* Do not reboot the device */
    while(1) {
        PROCESS_YIELD();
    }
    PROCESS_END();
}
