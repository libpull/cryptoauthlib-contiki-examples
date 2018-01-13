# Contiki CryptoAuthentication Examples

This repositories contains examples on how to use the CryptoAuthentication
HSM with Contiki-NG and the Sensortag CC2650 board.

The example contained in `runner.c` will try to calculate the hash using
the ATSHA204a and to calcaulte the hash and verify the signature using the
ATECC508a.

## Build

To prepare the repository you need to use the `autogen.sh` script.
It will download the dependencies and apply the patches stored 
in the `patch` folder.

You can then use the Makefile to compile the example and load it on the
device. The target device is already setted in the Makefile but you
can override it using:

    make TARGET=your-target BOARD=your-board
