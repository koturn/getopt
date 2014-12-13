### This Makefile was written for GNU Make. ###
ifeq ($(OPT),true)
	COPTFLAGS  := -flto -Ofast -march=native -DNDEBUG
	LDOPTFLAGS := -flto -Ofast -s
else
ifeq ($(DEBUG),true)
	COPTFLAGS  := -O0 -g3 -ftrapv -fstack-protector-all -D_FORTIFY_SOURCE=2
	LDLIBS     := -lssp
else
	COPTFLAGS  := -O3 -DNDEBUG
	LDOPTFLAGS := -O3 -s
endif
endif
C_WARNING_FLAGS := -Wall -Wextra -Wformat=2 -Wstrict-aliasing=2 \
                   -Wcast-align -Wcast-qual -Wconversion \
                   -Wfloat-equal -Wpointer-arith -Wswitch-enum \
                   -Wwrite-strings -pedantic

CC      := gcc
AR      := ar
CFLAGS  := -pipe $(C_WARNING_FLAGS) $(COPTFLAGS)
LDFLAGS := -pipe $(LDOPTFLAGS)
ARFLAGS := rcs

DST_DIR := lib
SRC_DIR := src
INC_DIR := include

TARGET  := $(DST_DIR)/libgetopt.a
OBJ1    := $(SRC_DIR)/getopt.o
OBJ2    := $(SRC_DIR)/getopt_long.o
SRC1    := $(OBJ:%.o=%.c)
SRC2    := $(OBJ:%.o=%.c)
HEADER  := $(INC_DIR)/getopt.h


.PHONY: all
all: $(TARGET)

$(TARGET): $(OBJ1) $(OBJ2)
	@if [ ! -d $(dir $@) ]; then \
		mkdir $(dir $@); \
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
