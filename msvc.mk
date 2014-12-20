!if "$(CRTDLL)" == "true"
CRTLIB = /MD$(DBG_SUFFIX)
!else
CRTLIB = /MT$(DBG_SUFFIX)
!endif

!if "$(DEBUG)" == "true"
COPTFLAGS   = /Od /GS /Zi $(CRTLIB)
AROPTFLAGS  =
MSVC_MACROS = /D_CRT_SECURE_NO_WARNINGS /D_CRT_NONSTDC_NO_WARNINGS \
              /D_USE_MATH_DEFINES
DBG_SUFFIX  = d
!else
COPTFLAGS   = /Ox /GL $(CRTLIB)
AROPTFLAGS  = /LTCG
MSVC_MACROS = /DNDEBUG /D_CRT_SECURE_NO_WARNINGS /D_CRT_NONSTDC_NO_WARNINGS \
              /D_USE_MATH_DEFINES
DBG_SUFFIX  =
!endif

CC = cl
AR = lib
RM = del /F

MACROS  = $(MSVC_MACROS)
CFLAGS  = /nologo $(COPTFLAGS) /W4 /c $(MACROS)
ARFLAGS = /nologo $(AROPTFLAGS)

DST_DIR = lib
SRC_DIR = src
INC_DIR = include

TARGET  = $(DST_DIR)\getopt$(DBG_SUFFIX).lib
OBJ1    = $(SRC_DIR)\getopt$(DBG_SUFFIX).obj
OBJ2    = $(SRC_DIR)\getopt_long$(DBG_SUFFIX).obj
SRC1    = $(SRC_DIR)\getopt.c
SRC2    = $(SRC_DIR)\getopt_long.c
HEADER  = $(INC_DIR)\getopt.h


all: $(TARGET)

$(TARGET): $(OBJ1) $(OBJ2)
	@if not exist $(DST_DIR)\NUL \
		mkdir $(DST_DIR)
	$(AR) $(ARFLAGS) $** /OUT:$@

$(OBJ1): $(SRC1) $(HEADER)
	$(CC) $(CFLAGS) $** /c /Fo$@

$(OBJ2): $(SRC2) $(HEADER)
	$(CC) $(CFLAGS) $** /c /Fo$@


clean:
	$(RM) $(TARGET) $(OBJ1) $(OBJ2)
cleanobj:
	$(RM) $(OBJ1) $(OBJ2)
