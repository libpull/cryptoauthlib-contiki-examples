# Set up the Sensortag cc2650 as default board
ifndef $(TARGET)
	TARGET=srf06-cc26xx
	BOARD=sensortag/cc2650
endif

CONTIKI_PROJECT=runner
all: $(CONTIKI_PROJECT)

CAUTHLIB_DIR = ext/cryptoauthlib/cryptoauthlib/lib/
PROJECTDIRS += $(CAUTHLIB_DIR) $(CAUTHLIB_DIR)/basic $(CAUTHLIB_DIR)/host $(CAUTHLIB_DIR)/hal
PROJECT_SOURCEFILES += $(notdir $(wildcard $(CAUTHLIB_DIR)/*.c $(CAUTHLIB_DIR)/basic/*.c $(CAUTHLIB_DIR)/host/*.c))
PROJECT_SOURCEFILES += atca_hal.c
CFLAGS +=-DATCA_HAL_I2C

PROJECTDIRS += ext/cryptoauthlib/hal
PROJECT_SOURCEFILES += hal_cc2650_i2c_contiki.c hal_cc2650_timer_contiki.c

# Include Contiki-NG makefile
CONTIKI=ext/contiki-ng
include $(CONTIKI)/Makefile.include
