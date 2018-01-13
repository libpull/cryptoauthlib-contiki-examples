ifndef $(TARGET)
	TARGET=srf06-cc26xx
	BOARD=sensortag/cc2650
endif

CONTIKI_PROJECT=runner
all: runner

#crypto:
#	(cd cryptoauthlib/lib/ && make cryptolib CC="$(CC)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)")
#CFLAGS+=-Icryptoauthlib/lib/ 
#LDFLAGS+=cryptoauthlib/lib/.build/libatca.a

CAUTHLIB_DIR = cryptoauthlib/lib/
CAUTHLIB_FILES = $(notdir $(wildcard $(CAUTHLIB_DIR)/*.c $(CAUTHLIB_DIR)/basic/*.c $(CAUTHLIB_DIR)/host/*.c))
CAUTHLIB_FILES += hal_cc2650_i2c.c atca_hal.c
CAUTHLIB_DIRS = $(CAUTHLIB_DIR) $(CAUTHLIB_DIR)/basic $(CAUTHLIB_DIR)/host $(CAUTHLIB_DIR)/hal

CFLAGS+=-DATCA_HAL_I2C

PROJECTDIRS += $(CAUTHLIB_DIRS)
PROJECT_SOURCEFILES += $(CAUTHLIB_FILES)

CONTIKI=ext/contiki-ng
include $(CONTIKI)/Makefile.include
