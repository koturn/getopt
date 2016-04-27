ifeq ($(DEBUG),true)
    OPT_CFLAGS  := -O0 -g3 -ftrapv -fstack-protector-all -D_FORTIFY_SOURCE=2
ifneq ($(shell echo $$OSTYPE),cygwin)
    OPT_CFLAGS  := $(OPT_CFLAGS) -fsanitize=address -fno-omit-frame-pointer
endif
    OPT_LDLIBS  := -lssp
else
ifeq ($(OPT),true)
    OPT_CFLAGS  := -flto -Ofast -march=native -DNDEBUG
    OPT_LDFLAGS := -flto -Ofast -s
else
ifeq ($(LTO),true)
    OPT_CFLAGS  := -flto -DNDEBUG
    OPT_LDFLAGS := -flto
else
    OPT_CFLAGS  := -O3 -DNDEBUG
    OPT_LDFLAGS := -O3 -s
endif
endif
endif

WARNING_CFLAGS := -Wall -Wextra -Wformat=2 -Wstrict-aliasing=2 \
                  -Wcast-align -Wcast-qual -Wconversion \
                  -Wfloat-equal -Wpointer-arith -Wswitch-enum \
                  -Wwrite-strings -pedantic

CC         := gcc
AR         := ar
MKDIR      := mkdir -p
CP         := cp
RM         := rm -f
CTAGS      := ctags
STD_CFLAGS := $(if $(STDC), $(addprefix -std=, $(STDC)),)
CFLAGS     := -pipe $(STD_CFLAGS) $(WARNING_CFLAGS) $(OPT_CFLAGS) $(INCS) $(MACROS)
LDFLAGS    := -pipe $(OPT_LDFLAGS)
ARFLAGS    := rcs
CTAGSFLAGS := -R --languages=c
LDLIBS     := $(OPT_LDLIBS)
PREFIX     := /usr/local

DST_DIR    := lib
SRC_DIR    := src
INC_DIR    := include
TARGET     := $(DST_DIR)/libgetopt.a
SRCS       := $(addprefix $(SRC_DIR)/, $(addsuffix .c, getopt getopt_long))
OBJS       := $(SRCS:.c=.o)
DEPENDS    := depends.mk
INSTALLDIR := $(if $(PREFIX), $(PREFIX),/usr/local)/lib


.PHONY: all depends syntax ctags install uninstall clean cleanobj
all: $(TARGET)

$(TARGET): $(OBJS)
	@[ ! -d $(@D) ] && $(MKDIR) $(@D) || :
	$(AR) $(ARFLAGS) $@ $^


-include $(DEPENDS)

depends:
	$(CC) -MM $(SRCS) > $(DEPENDS)

syntax:
	$(CC) $(SRCS) $(STD_CFLAGS) -fsyntax-only $(WARNING_CFLAGS) $(INCS) $(MACROS)

ctags:
	$(CTAGS) $(CTAGSFLAGS)

install: $(INSTALLDIR)/$(notdir $(TARGET))

$(INSTALLDIR)/$(notdir $(TARGET)): $(TARGET)
	@[ ! -d $(@D) ] && $(MKDIR) $(@D) || :
	$(CP) $< $@

uninstall:
	$(RM) $(INSTALLDIR)/$(TARGET)

clean:
	$(RM) $(TARGET) $(OBJS)

cleanobj:
	$(RM) $(OBJS)
