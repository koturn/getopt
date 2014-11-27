CC = cl
AR = lib
RM = del /F

MACROS  = /D_CRT_SECURE_NO_WARNINGS /D_SECURE_SCL=0
CFLAGS  = /nologo /c /O2 /W4 $(MACROS)
LDFLAGS = /nologo /O2
ARFLAGS = /nologo

DST_DIR = lib
SRC_DIR = src
INC_DIR = include

TARGET  = $(DST_DIR)\getopt.lib
OBJ1    = $(SRC_DIR)\getopt.obj
OBJ2    = $(SRC_DIR)\getopt_long.obj
SRC1    = $(OBJ1:.obj=.c)
SRC2    = $(OBJ2:.obj=.c)
HEADER  = $(INC_DIR)\getopt.h


.SUFFIXES: .c .obj
.c.obj:
	$(CC) $(CFLAGS) $** /c /Fo$@


all: $(TARGET)

$(TARGET): $(OBJ1) $(OBJ2)
	@if not exist $(DST_DIR)\NUL \
	    mkdir $(DST_DIR)
	$(AR) $(ARFLAGS) $** /OUT:$@

$(OBJ1): $(SRC1) $(HEADER)

$(OBJ2): $(SRC2) $(HEADER)


clean:
	$(RM) $(TARGET) $(OBJ1) $(OBJ2)
cleanobj:
	$(RM) $(OBJ1) $(OBJ2)
