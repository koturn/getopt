### This Makefile was written for GNU Make. ###
ifeq ($(OPT),true)
	OPT_CFLAGS  := -flto -Ofast -march=native -DNDEBUG
	OPT_LDFLAGS := -flto -Ofast -s
else
ifeq ($(DEBUG),true)
	OPT_CFLAGS  := -O0 -g3 -ftrapv -fstack-protector-all -D_FORTIFY_SOURCE=2
	OPT_LDLIBS  := -lssp
else
	OPT_CFLAGS  := -O3 -DNDEBUG
	OPT_LDFLAGS := -O3 -s
endif
endif
WARNING_CFLAGS := -Wall -Wextra -Wformat=2 -Wstrict-aliasing=2 \
                  -Wcast-align -Wcast-qual -Wconversion \
                  -Wfloat-equal -Wpointer-arith -Wswitch-enum \
                  -Wwrite-strings -pedantic

CC      := gcc
AR      := ar
CFLAGS  := -pipe $(WARNING_CFLAGS) $(OPT_CFLAGS)
LDFLAGS := -pipe $(OPT_LDFLAGS)
LDLIBS  := $(OPT_LDLIBS)
ARFLAGS := rcs

DST_DIR := lib
SRC_DIR := src
INC_DIR := include

TARGET  := $(DST_DIR)/libgetopt.a
OBJ1    := $(SRC_DIR)/getopt.o
OBJ2    := $(SRC_DIR)/getopt_long.o
SRC1    := $(OBJ:.o=.c)
SRC2    := $(OBJ:.o=.c)
HEADER  := $(INC_DIR)/getopt.h


.PHONY: all
all: $(TARGET)

$(TARGET): $(OBJ1) $(OBJ2)
	@if [ ! -d $(@D) ]; then \
		mkdir $(@D); \
	fi
	$(AR) $(ARFLAGS) $@ $^

$(OBJ1): $(SRC1) $(HEADER)

$(OBJ2): $(SRC2) $(HEADER)


.PHONY: clean
clean:
	$(RM) $(TARGET) $(OBJ1) $(OBJ2)
.PHONY: cleanobj
cleanobj:
	$(RM) $(OBJ1) $(OBJ2)
